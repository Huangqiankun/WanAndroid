import { HMLifecycle, HMLifecycleContext, HMRouterMgr, IHMLifecycle } from "@hadss/hmrouter";
import { FeatureHomePath, LogUtil, UserInfoResult, UserStorageUtil } from "common";
import { PhoneApi } from "../net/PhoneApi";


@HMLifecycle({ lifecycleName: "SplashLifeCycle" })
export class SplashLifeCycle implements IHMLifecycle {
  onPrepare(ctx: HMLifecycleContext): void {
    LogUtil.warn(`WelcomeLifecycle to page onPrepare ${ctx.navContext?.pathInfo.name}`);
  }

  onShown(ctx: HMLifecycleContext): void {
    LogUtil.warn(`WelcomeLifecycle to page onShown ${ctx.navContext?.pathInfo.name}`);
    // 启动一个延时任务，比如 2000 毫秒（2秒）
    // 这样写就不会报红了
    this.checkAndJump();

  }

  private async checkAndJump() {
    // 1. 先等待 2 秒（保证启动页动画展示完整）
    // 加上花括号 { }，明确告诉编译器：我这里不返回任何东西
    await new Promise<void>((resolve) => {
      setTimeout(resolve, 2000);
    });
    const isLogin = UserStorageUtil.isLogin()
    LogUtil.warn(`WelcomeLifecycle isLogin=${isLogin}`)
    if (!isLogin) {
      this.jumpToLogin()
      return
    }
     this.checkLoginStatus()

  }

  private jumpToLogin() {
    HMRouterMgr.replace({ pageUrl: FeatureHomePath.LOGIN, param: { "from": "welcome" } });
  }

  private async checkLoginStatus() {
    LogUtil.warn(`WelcomeLifecycle checkLoginStatus`)
    try {
      // // 调用你的加载用户信息接口（假设方法名为 getUserInfo）
      // // 这里的请求会自动走你配置好的 axios 拦截器
      // // 如果拦截器检测到 401，会自动执行你写好的“清理并跳转登录”逻辑
      // // 4. 接口校验通过：说明没失效，跳转到首页
      PhoneApi.getUserInfo().then((userInfoResult: UserInfoResult) => {
        LogUtil.debug("checkLoginStatus->getUserInfo-> " + JSON.stringify(userInfoResult))
        HMRouterMgr.replace({ pageUrl: FeatureHomePath.HOME, param: { "from": "Loading" } })
      })

    } catch (er) {
      console.error("验证登录失效或网络异常", er);
    }
  }
}