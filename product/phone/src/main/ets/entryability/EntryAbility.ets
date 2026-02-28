import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import {
  AppUtil,
  LogUtil,
  CrashUtil,
  DeviceUtil,
  InternalAxiosRequestConfig,
  NetworkManager,
  ToastUtil,
  UserStorageUtil,
  FeatureHomePath
} from 'common';
import BuildProfile from 'BuildProfile';
import { HMRouterMgr } from '@hadss/hmrouter';

const DOMAIN = 0x0000;


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.initSdk()
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }


  private initSdk(): void {
    this.initUtil()
    this.initHMRoute()
    this.initNetWork()
  }

  private initHMRoute() {
    HMRouterMgr.openLog("INFO")
    HMRouterMgr.init({
      context: this.context
    })
  }

  private initUtil(): void {
    AppUtil.init(this.context);
    UserStorageUtil.init()
    //初始化日志  0x1010  设置日志对应的领域标识, 'WanAndroid' 设置日志标识 , true 是否打印日志 , true 日志打印方式 true-hilog、false-console
    LogUtil.init(0x1010, 'WanAndroid', BuildProfile.DEBUG, true);
    //异常工具捕获初始化
    CrashUtil.onHandled((exceptionInfo) => {
    })
  }

  private initNetWork(): void {
    NetworkManager.getInstance().init({
      baseUrl: BuildProfile.BASE_URL,
      //请求拦截器
      headerHandler: (config: InternalAxiosRequestConfig) => {
        // 从内存/缓存中取出 Cookie 字符串
        const cookieStr = UserStorageUtil.getCookStr();
        if (cookieStr) {
          // 这里的 Key 必须叫 'Cookie'
          config.headers['Cookie'] = cookieStr;
        }
        return config
      },
      // 2. 【响应拦截】提取并保存 Cookie
      onHeadersReceived: (headers) => {
        // Axios 返回的 set-cookie 通常是一个数组，或者字符串
        // 在玩Android接口中，它是 'set-cookie' 字段
        const setCookie = headers['set-cookie'] as string[] | string;
        if (setCookie) {
          // const oldCookieStr = UserStorageUtil.getCookStr();
          // if (oldCookieStr) {
          //   return
          // }

          // 处理 Cookie 逻辑 (调用下面的工具方法)
          const cookieStr = this.processSetCookie(setCookie);
          // 如果解析到了有效的 Cookie，就存起来
          if (cookieStr && cookieStr.length > 0 && cookieStr.search("token_pass") > 0) {
            // 这里为了演示简单直接覆盖，实际业务可能需要和旧 Cookie 合并
            // AppStorage.setOrCreate(APP_COOKIE_KEY, cookieStr);

            UserStorageUtil.saveCookie(cookieStr)
            console.info('更新 Cookie 成功:', cookieStr);
          }
        }
      },
      //网络请求错误、接口业务报错回调
      errorHandler: (code, msg) => {
        if (code == -1001) {
          //登录失效
          HMRouterMgr.removeAll();
          UserStorageUtil.clearUserInfo()
          //  这里将会跳转至登录页面
          HMRouterMgr.replace({ pageUrl: FeatureHomePath.LOGIN, param: { "from": "NetWork" } });
          return
        }
        //其他code 根据业务场景来处理，吐司已经在内部拦截器实现，当然也可以在这里弹吐司
      }
    })
  }

  /**
   * 工具方法：解析 Set-Cookie 数组，拼接成 "key=value; key2=value2" 格式
   */
  private processSetCookie(setCookie: string[] | string): string {
    let cookies: string[] = [];

    // 统一转成数组处理
    const cookieList = Array.isArray(setCookie) ? setCookie : [setCookie];

    cookieList.forEach(item => {
      // item 格式通常是: "JSESSIONID=xyz; Path=/; HttpOnly"
      // 我们只需要分号前的部分: "JSESSIONID=xyz"
      const simpleCookie = item.split(';')[0];
      if (simpleCookie) {
        cookies.push(simpleCookie);
      }
    });

    // 拼接成请求头需要的格式: "k=v; k=v"
    return cookies.join('; ');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    this.initWindow(windowStage)
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  private initWindow(windowStage: window.WindowStage): void {
    windowStage.getMainWindow((err, data) => {
      const windowClass = data;
      // 1. 设置窗口全屏（内容延伸到状态栏）
      windowClass.setWindowLayoutFullScreen(true);
      // 2. 隐藏状态栏（如果需要彻底全屏）或保持显示但背景透明
      windowClass.setWindowSystemBarEnable(['status', 'navigation']);
      // 获取并存储初始状态栏高度
      const type = window.AvoidAreaType.TYPE_SYSTEM;
      const avoidArea = windowClass.getWindowAvoidArea(type);
      AppStorage.setOrCreate('statusBarHeight', px2vp(avoidArea.topRect.height));

      // 监听避让区动态变化
      windowClass.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          AppStorage.setOrCreate('statusBarHeight', px2vp(data.area.topRect.height));
        }
      });
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}