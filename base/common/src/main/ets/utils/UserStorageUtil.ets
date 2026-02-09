import { ConstantUtil } from './ConstantUtil';
import { PreferencesUtil } from '@pura/harmony-utils';

export class UserStorageUtil {
  static init() {
    PersistentStorage.persistProp(ConstantUtil.USER_COOKIE_KEY, "");
    PersistentStorage.persistProp(ConstantUtil.IS_LOGIN_KEY, false);
    AppStorage.setOrCreate(ConstantUtil.USER_COOKIE_KEY, PreferencesUtil.getStringSync(ConstantUtil.USER_COOKIE_KEY));
    AppStorage.setOrCreate(ConstantUtil.IS_LOGIN_KEY, PreferencesUtil.getBooleanSync(ConstantUtil.IS_LOGIN_KEY));

  }

  /**
   * 存储用户信息（登录成功后调用）
   */
  static saveCookie(cookieStr:string){
    AppStorage.setOrCreate(ConstantUtil.USER_COOKIE_KEY, cookieStr);
    AppStorage.setOrCreate(ConstantUtil.IS_LOGIN_KEY, true);
    PreferencesUtil.put(ConstantUtil.USER_COOKIE_KEY, cookieStr)
    PreferencesUtil.put(ConstantUtil.IS_LOGIN_KEY, true)
  }

  /**
   * 单独获取 UserId
   */
  static getCookStr(): string {
    return AppStorage.get<string>(ConstantUtil.USER_COOKIE_KEY) || "";
    // return PreferencesUtil.getStringSync(ConstantUtil.USER_COOKIE_KEY)
  }


  /**
   * 判断是否登录
   */
  static isLogin(): boolean {
    return AppStorage.get<boolean>(ConstantUtil.IS_LOGIN_KEY) || false;
    // return PreferencesUtil.getBooleanSync(ConstantUtil.IS_LOGIN_KEY)
  }

  /**
   * 清除用户信息（退出登录时调用）
   */
  static clearUserInfo() {
    AppStorage.setOrCreate(ConstantUtil.USER_COOKIE_KEY, "");
    AppStorage.setOrCreate(ConstantUtil.IS_LOGIN_KEY, false);
    PreferencesUtil.delete(ConstantUtil.USER_COOKIE_KEY)
    PreferencesUtil.delete(ConstantUtil.IS_LOGIN_KEY)
  }
}