import { Document } from "mongoose";
import { IChat, IMessage } from "./IChat";
import { v4 as uuidv4 } from "uuid";
import UserModel from "../users/model";
import { ChatModel, MessageModel } from "./model";

const chatResolver = {
  Query: {
    getMessages: async (parent: any, args: any, context: any, info: any) => {
      const { uid, page } = args;
      // getting only messages from the last 24 hours
      try {
        const pageNumber = page; // Replace with the desired page number
        const pageSize = 30; // Replace with the desired page size
        const skip =
          (pageNumber - 1) * pageSize > 0 ? (pageNumber - 1) * pageSize : 0;
        const aggregationPipeline = [
          {
            $match: {
              $or: [{ sender: uid }, { receiver: uid }],
            },
          },
          {
            $lookup: {
              from: "users",
              localField: "sender",
              foreignField: "uid",
              as: "sender",
            },
          },
          {
            $unwind: "$sender",
          },
          {
            $lookup: {
              from: "users",
              localField: "receiver",
              foreignField: "uid",
              as: "receiver",
            },
          },
          {
            $unwind: "$receiver",
          },
          {
            $project: {
              _id: 0,
              message_id: 1,
              chat_id: 1,
              sender_id: 1,
              receiver_id: 1,
              message: 1,
              created_at: 1,
              updated_at: 1,
              media: 1,
              seenBy: 1,
              "sender.uid": 1,
              "sender.username": 1,
              "sender.profile_pic": 1,
              "receiver.uid": 1,
              "receiver.username": 1,
              "receiver.profile_pic": 1,
            },
          },
        ];

        const messages = (await MessageModel.aggregate(aggregationPipeline)).map((message: any) => ({
          message_id: message.message_id,
          chat_id: message.chat_id,
          sender_id: message.sender.uid,
          partner_id: message.receiver.uid,
          message: message.message,
          media: message.media,
          seenBy: message.seenBy,
          sender: message.sender,
          created_at: message.created_at,
        }));

        // const _messages = messages.map((message: any) => ({
        //   message_id: message.message_id,
        //   chat_id: message.chat_id,
        //   sender_id: message.sender.uid,
        //   partner_id: message.receiver.uid,
        //   message: message.message,
        //   media: message.media,
        //   seenBy: message.seenBy,
        //   sender: message.sender,
        //   created_at: message.created_at,
        // }))

        return messages;
      } catch (err) {
        console.log(err);
      }
    },
    getChats: async (parent: any, args: any, context: any, info: any) => {
      const { uid } = args;
      try {
        const user = await UserModel.findOne({ uid });

        if (!user) {
          throw new Error("User not found");
        }

        const chatIds = user.chats;

        const messages = await MessageModel.find({ chat_id: { $in: chatIds } });

        const lastMessages = messages.reduce((acc, message) => {
          if (!acc[message.chat_id]) {
            acc[message.chat_id] = {};
          }
          if (
            !acc[message.chat_id][message.sender] ||
            acc[message.chat_id][message.receiver] ||
            acc[message.chat_id][message.sender].created_at <
              message.created_at ||
            acc[message.chat_id][message.receiver].created_at <
              message.created_at
          ) {
            acc[message.chat_id] = message;
          }
          return acc;
        }, {});

        // console.log(lastMessages);
        // const latestMessagesByChatAndUser = messages.reduce((acc, message) => {
        //   if (!acc[message.chat_id]) {
        //     acc[message.chat_id] = {};
        //   }
        //   if (
        //     !acc[message.chat_id][message.sender_id] ||
        //     acc[message.chat_id][message.sender_id].created_at <
        //       message.created_at
        //   ) {
        //     acc[message.chat_id] = message;
        //   }
        //   return acc;
        // }, {});
        const uniqueUserIds = [
          ...new Set(
            messages
              .map((message) => message.sender)
              .concat(messages.map((message) => message.receiver))
          ),
        ];

        const userPromises = uniqueUserIds.map((userId) =>
          UserModel.findOne({ uid: userId })
        );
        const users = await Promise.all(userPromises);

        const usersDict = users.reduce((acc, user) => {
          acc[user.uid] = user;
          return acc;
        }, {});

        const chats = Object.values(lastMessages).map((message: any) => ({
          chat_id: message.chat_id,
          partner_id:
            message.sender === uid ? message.receiver : message.sender,
          partner:
            usersDict[
              message.sender === uid ? message.receiver : message.sender
            ],
          last_message: message.message,
          last_message_time: message.created_at,
        }));

        return chats.map((chat: any) => ({
          chat_id: chat.chat_id,
          partner_id: chat.partner.uid,
          partner: chat.partner,
          media: chat.media,
          last_message: chat.last_message,
          last_message_time: Math.floor(
            new Date(chat.last_message_time).getTime()
          ).toString(),
        }));
        // return "chats";
      } catch (err) {
        console.log(err);
      }
    },
  },
};

export default chatResolver;
