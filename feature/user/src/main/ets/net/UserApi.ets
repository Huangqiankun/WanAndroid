import { Any, GET, Path, UserInfoResult } from "common";
import { CollectListResult } from "../model/UserReponseResult";

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

  /**
   * 我的收藏文章列表
   * @param page
   */
  @GET("/lg/collect/list/{page}/json")
  static async getCollectList(@Path("page") page: number): Promise<CollectListResult> {
    return {} as CollectListResult
  }
}