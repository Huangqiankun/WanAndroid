import { Body, GET, POST, Query, Path } from "common";
import { BannerResult, HomeListArticleResult, LoginResult } from "../model/ResponseResult";
import { List } from "@kit.ArkTS";

export class HomeApi {
  /**
   * 用户登录
   * @param username
   * @param password
   * @returns
   */
  @POST("/user/login")
  static async login(@Query("username") username: string, @Query("password") password: string): Promise<LoginResult> {
    return {} as LoginResult
  }


  /**
   * 获取首页banner内容
   * @returns
   */
  @GET("/banner/json")
  static async homeBannerLst(): Promise<BannerResult[]> {
    return []
  }

  /**
   * 获取首页文章列表
   * @param page
   * @returns
   */
  @GET("/article/list/{page}/json")
  static  async getHomeList(@Path("page") page: number): Promise<HomeListArticleResult> {
    return {} as HomeListArticleResult
  }
}