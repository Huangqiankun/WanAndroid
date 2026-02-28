import { Any, GET, UserInfoResult } from "common";

export class UserApi {
  /**
   * 获取用户信息
   * @returns
   */
  @GET("/user/lg/userinfo/json")
  static async getUserInfo(): Promise<UserInfoResult> {
    return {} as UserInfoResult
  }

  /**
   * 退出登录
   * @returns
   */
  @GET("/user/logout/json")
  static async loginOut(): Promise<Any> {
    return null
  }
}