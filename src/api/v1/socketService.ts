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
      console.log(chat);

      if (chat === null) throw new Error("Chat not found");

      const messageData = {
        chat_id: chat.chat_id,
        message_id: uuidv4(),
        message,
        sender: sender_id,
        receiver: partner_id,
      };

      console.log(messageData);

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
