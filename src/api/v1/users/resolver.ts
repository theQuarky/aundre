import IUser from "./IUser";
import UserModal from "./model";

const userResolver = {
  Query: {
    getUser: async (parent: any, args: any, context: any, info: any) => {
      const { uid } = args;
      console.log(args);
      try {
        const user: IUser | null = await UserModal.findOne({ uid });
        return user;
      } catch (err) {
        return err;
      }
    },
  },
};

export default userResolver;
