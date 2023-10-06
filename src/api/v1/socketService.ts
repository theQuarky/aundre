import { Socket, Server } from "socket.io";
import { DefaultEventsMap } from "socket.io/dist/typed-events";
import { ChatModel, MessageModel } from "./chat/model";
import { v4 as uuidv4 } from "uuid";
import UserModel from "./users/model";

const rooms: any = {};

export const socketService = (
  socket: Socket,
  io: Server<DefaultEventsMap, DefaultEventsMap, DefaultEventsMap, any>
) => {
  const messageChangeStream = MessageModel.watch();
  messageChangeStream.on("change", async (change) => {
    // console.log(`update_message ${change.operationType}`);
    // if (change.operationType === "update") {
    //   const change_id = change.documentKey._id;

    //   const message = await MessageModel.findOne({
    //     _id: change_id,
    //   });

    //   const sender = await UserModel.findOne({
    //     uid: message.sender,
    //   });

    //   const data = {
    //     message_id: message.message_id,
    //     chat_id: message.chat_id,
    //     sender_id: message.sender,
    //     partner_id: message.receiver,
    //     message: message.message,
    //     sender: sender,
    //     created_at: Math.floor(
    //       new Date(message.created_at).getTime()
    //     ).toString(),
    //     seenBy: message.seenBy,
    //   };

    //   const emitTo = [];

    //   if (rooms[message.receiver] !== undefined) {
    //     emitTo.push(rooms[message.receiver]);
    //   }

    //   if (rooms[message.sender] !== undefined) {
    //     emitTo.push(rooms[message.sender]);
    //   }

    //   socket.to(emitTo).emit("update_message", data);
    // }

    if (change.operationType === "insert") {
      const sender = await UserModel.findOne({
        uid: change.fullDocument.sender,
      });

      const data = {
        message_id: change.fullDocument.message_id,
        chat_id: change.fullDocument.chat_id,
        sender_id: change.fullDocument.sender,
        partner_id: change.fullDocument.receiver,
        message: change.fullDocument.message,
        sender: sender,
        created_at: Math.floor(
          new Date(change.fullDocument.created_at).getTime()
        ).toString(),
        seenBy: change.fullDocument.seenBy,
      };

      const emitTo = [];

      if (rooms[change.fullDocument.receiver] !== undefined) {
        emitTo.push(rooms[change.fullDocument.receiver]);
      }

      if (rooms[change.fullDocument.sender] !== undefined) {
        emitTo.push(rooms[change.fullDocument.sender]);
      }

      socket.to(emitTo).emit("new_message", data);
    }
  });

  socket.on("join", async (data) => {
    try {
      if (rooms[data["uid"]] === undefined) {
        rooms[data["uid"]] = socket.id;
        socket.join(socket.id); // Join the socket room
      }
      console.log(`ROOMS: ${JSON.stringify(rooms)}`);
    } catch (error) {
      console.log(error);
    }
  });

  socket.on("seen", async (data) => {
    try {
      console.log("seen event called");

      const { uid, message_id } = data;

      if (message_id === null) return;
      if (uid === null) return;
      console.log("Checkpoint -1");
      const messages = await MessageModel.findOne({
        message_id,
      });
      console.log("Checkpoint 0 : ", messages);
      let seenBy = messages.seenBy;
      console.log("Checkpoint 0.5 : ", seenBy, uid);

      console.log("Checkpoint 1 : ", seenBy);
      seenBy.push({
        uid,
        seenAt: Math.floor(new Date().getTime()).toString(),
      });

      // keep only unique values in array
      seenBy = seenBy.filter(
        (thing: any, index: any, self: any) =>
          index === self.findIndex((t: any) => t.uid === thing.uid)
      );

      console.log("Checkpoint 2 : ", seenBy);
      await MessageModel.updateOne({ message_id }, { $set: { seenBy } });
      console.log("Checkpoint 3 : ", seenBy);

      const message = await MessageModel.findOne({
        message_id,
      });

      const sender = await UserModel.findOne({
        uid: message.sender,
      });

      const _data = {
        message_id: message.message_id,
        chat_id: message.chat_id,
        sender_id: message.sender,
        partner_id: message.receiver,
        message: message.message,
        sender: sender,
        created_at: Math.floor(
          new Date(message.created_at).getTime()
        ).toString(),
        seenBy: message.seenBy,
      };

      const emitTo = [];

      if (rooms[message.receiver] !== undefined) {
        emitTo.push(rooms[message.receiver]);
      }

      if (rooms[message.sender] !== undefined) {
        emitTo.push(rooms[message.sender]);
      }

      socket.to(emitTo).emit("update_message", _data);
    } catch (error) {
      console.log(error);
    }
  });

  socket.on("chat_message", async (msg) => {
    try {
      const { message, sender_id, partner_id } = msg;
      let chat: any;
      let chat_id = null;

      const messages = await MessageModel.find({
        $or: [
          { sender: sender_id, receiver: partner_id },
          { sender: partner_id, receiver: sender_id },
        ],
      });

      if (messages.length > 0) {
        chat_id = messages[0].chat_id;
      }

      if (chat_id === null) {
        const chatData = {
          chat_id: uuidv4(),
          messages: [],
        };

        chat = await ChatModel.create(chatData);
        await UserModel.updateMany(
          { uid: { $in: [sender_id, partner_id] } },
          { $push: { chats: chat.chat_id } }
        );
      } else {
        chat = await ChatModel.findOne({ chat_id });
      }

      if (chat === null) throw new Error("Chat not found");

      const messageData = {
        chat_id: chat.chat_id,
        message_id: uuidv4(),
        message:
          message.message == null && message.media_url != null
            ? ""
            : message.message,
        sender: sender_id,
        receiver: partner_id,
        seenBy: [
          {
            uid: sender_id,
            seenAt: Math.floor(new Date().getTime()).toString(),
          },
        ],
        media: message.media_url,
      };

      const _message = await MessageModel.create(messageData);

      await ChatModel.updateOne(
        { chat_id: chat.chat_id },
        { $push: { messages: _message.message_id } },
        { upsert: true }
      );
    } catch (error) {
      console.log(error);
    }
  });
  socket.on("disconnect", () => {
    console.log("user disconnected");

    //remove user from rooms
    for (const [key, value] of Object.entries(rooms)) {
      if (value === socket.id) {
        delete rooms[key];
      }
    }
  });
};
