import { Body, POST, Query } from "common";
import { LoginResult } from "../model/ResponseResult";

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
}