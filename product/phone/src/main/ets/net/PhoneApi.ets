import { GET, UserInfoResult } from "common";

export class PhoneApi {
  /**
   * 获取用户信息
   * @returns
   */
  @GET("/user/lg/userinfo/json")
  static async getUserInfo(): Promise<UserInfoResult> {
    return {} as UserInfoResult
  }
}