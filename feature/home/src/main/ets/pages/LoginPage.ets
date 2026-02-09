import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { FeatureHomePath, LogUtil, ToastUtil, UserStorageUtil } from "common";
import { LoginResult } from "../model/ResponseResult";
import { HomeApi } from "../net/HomeApi";
import { JSON } from "@kit.ArkTS";


@HMRouter({ pageUrl: FeatureHomePath.LOGIN })
@ComponentV2
@Preview
export struct LoginPage {
  @Local inputPwd: string = ""
  @Local inputUser: string = ""

  private isLoginEnabled(): boolean {
    return this.inputUser.length > 0 && this.inputPwd.length > 0;
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.home_svg_phone'))
          .width('12vp')
          .height('16vp')
        TextInput({ placeholder: '请输入用户名', text: $$this.inputUser })
          .backgroundColor(Color.Transparent)
          .borderRadius(0)
          .fontSize('16vp')
          .type(InputType.Normal)
          .fontColor(Color.White)
          .placeholderColor('#A9A9A9')
      }
      .width('100%')

      Divider()
        .vertical(false)
        .strokeWidth(0.8)
        .color($r('app.color.common_color_grey_d2'))
        .lineCap(LineCapStyle.Round)
        .margin({ top: 12 })

      Row() {
        Image($r('app.media.home_svg_msg_code')).width('15vp').height('16vp')

        TextInput({ placeholder: '请输入密码', text: $$this.inputPwd })
          .backgroundColor(Color.Transparent)
          .borderRadius(0)
          .fontSize('16vp')
          .type(InputType.Password)
          .fontColor(Color.White)
          .placeholderColor('#A9A9A9')
          .layoutWeight(1)


      }.margin({ top: 31 })
      .width('100%')

      Divider()
        .vertical(false)
        .strokeWidth(0.8)
        .color($r('app.color.common_color_grey_d2'))
        .lineCap(LineCapStyle.Round)
        .margin({ top: 12 })

      Button('登录')
        .fontSize(19)
        .enabled(this.isLoginEnabled())
        .padding({ top: 18, bottom: 18 })
        .margin({ top: 37 })
        .borderRadius(30)
        .stateStyles({
          normal: {
            .backgroundColor($r('app.color.common_color_theme'))
          },
          disabled: {
            .backgroundColor($r('app.color.common_color_40theme'))
          }
        })
        .width('100%')
        .onClick(() => {
          this.pwdLogin(this.inputUser, this.inputPwd)
        })

    }
    .width('100%')
    .height('100%')
    .padding({ top: 300, left: 30, right: 30 })
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .backgroundImage($r('app.media.home_login'))
  }

  private loginSuccess(response: LoginResult) {
    //跳转至首页
    HMRouterMgr.replace({pageUrl: FeatureHomePath.HOME, param: { "from": "Login" }})
  }

  pwdLogin(inputUser: string, inputPwd: string) {
    HomeApi.login(inputUser,inputPwd).then((response: LoginResult) => {
      LogUtil.debug(`pwdLogin->result ->${JSON.stringify(response)}`)
      this.loginSuccess(response)
    })
  }
}