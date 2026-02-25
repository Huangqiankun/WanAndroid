import { HMLifecycle, HMLifecycleContext, HMRouterMgr, IHMLifecycle } from "@hadss/hmrouter";
import { FeatureHomePath, LogUtil, ProductPhonePath, UserInfoResult, UserStorageUtil } from "common";
import { PhoneApi } from "../net/PhoneApi";


@HMLifecycle({ lifecycleName: "SplashLifeCycle" })
export class SplashLifeCycle implements IHMLifecycle {
  onShown(ctx: HMLifecycleContext): void {
    LogUtil.warn(`WelcomeLifecycle to page onShown ${ctx.navContext?.pathInfo.name}`);
    this.checkAndJump();
  }

  private async checkAndJump() {
    await new Promise<void>((resolve) => {
      setTimeout(resolve, 2000);
    });
    const isLogin = UserStorageUtil.isLogin()
    LogUtil.warn(`WelcomeLifecycle isLogin=${isLogin}`)
    if (!isLogin) {
      //如果没有登录，直接跳转登录页面
      this.jumpToLogin()
      return
    }
    //如果登录了，先调用用户信息接口，确保cookie没有过期
    this.checkLoginStatus()
  }

  private jumpToLogin() {
    HMRouterMgr.replace({ pageUrl: FeatureHomePath.LOGIN, param: { "from": "welcome" } });
  }

  private async checkLoginStatus() {
    LogUtil.warn(`WelcomeLifecycle checkLoginStatus`)
    try {
      // // 这里的请求会自动会走配置好的 axios 拦截器
      // // 接口校验通过：说明没失效，跳转到首页
      PhoneApi.getUserInfo().then((userInfoResult: UserInfoResult) => {
        LogUtil.debug("checkLoginStatus->getUserInfo-> " + JSON.stringify(userInfoResult))
        HMRouterMgr.replace({ pageUrl: ProductPhonePath.MAIN, param: { "from": "Loading" } })
      })

    } catch (er) {
      console.error("验证登录失效或网络异常", er);
    }
  }
}