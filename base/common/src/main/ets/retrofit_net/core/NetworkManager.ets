import axios, {
  AxiosInstance,
  AxiosResponse,
  AxiosError,
  InternalAxiosRequestConfig,
  AxiosRequestConfig
} from '@ohos/axios';
import { Any, ToastUtil } from '@pura/harmony-utils';

/**
 * 1. 基础响应体接口
 * T 代表接口返回的 result 字段的类型
 */
export interface BaseResponse<T = null> {
  errorCode: number; // 业务状态码，如 200, 401, 500
  errorMsg: string; // 提示信息
  data: T; // 泛型数据
}

/**
 * 2. 网络库配置接口
 * 由主工程 (EntryAbility) 初始化时传入
 */
export interface NetworkConfig {
  baseUrl: string; // 必传：基础域名
  timeout?: number; // 选传：超时时间，默认 10000ms

  /**
   * 钩子函数：自定义请求头处理
   * 作用：主工程可以在这里注入 Token、Language、DeviceId 等 Header
   */
  headerHandler?: (config: InternalAxiosRequestConfig) => InternalAxiosRequestConfig;

  /**
   * 钩子函数：全局错误处理
   * 作用：主工程可以在这里处理 -1001 登录失效跳转、统一弹窗提示等
   * @param code 业务状态码 (如 -1001, -1)
   * @param msg 错误信息
   */
  errorHandler?: (code: number, msg: string) => void;

  /**
   * 响应头钩子
   * 类型为 Record<string, Any> 以兼容 Axios 复杂的 header 类型
   */
  onHeadersReceived?: (headers: Record<string, Any>) => void;
}

/**
 * 3. 内部请求选项接口
 * (配合装饰器使用，不对外暴露)
 */
export interface RequestOptions {
  url: string;
  method: string;
  pathParams?: Record<string, Any>; // 路径参数 /user/{id}
  queryParams?: Record<string, Any>; // 查询参数 ?id=1
  data?: Any; // Body 参数
}


/**
 * 核心管理类 (单例模式)
 */
export class NetworkManager {
  private static instance: NetworkManager;
  private axiosInstance: AxiosInstance;
  // 默认配置，防止未初始化时报错
  private config: NetworkConfig = { baseUrl: '' };

  private constructor() {
    // 初始创建，后续 init 会覆盖配置
    this.axiosInstance = axios.create();
  }

  /**
   * 获取单例
   */
  public static getInstance(): NetworkManager {
    if (!NetworkManager.instance) {
      NetworkManager.instance = new NetworkManager();
    }
    return NetworkManager.instance;
  }

  /**
   * 初始化方法 (必须在 App 启动时调用)
   * @param config 全局配置
   */
  public init(config: NetworkConfig) {
    this.config = config;
    // 创建 Axios 实例
    this.axiosInstance = axios.create({
      baseURL: config.baseUrl,
      timeout: config.timeout || 10000,
      headers: {
        'Content-Type': 'application/json;charset=utf-8'
      }
    });

    // 初始化拦截器
    this.initInterceptors();
  }

  /**
   * 初始化拦截器
   */
  private initInterceptors() {
    // --- 请求拦截器 ---
    this.axiosInstance.interceptors.request.use(
      (config: InternalAxiosRequestConfig) => {
        // 如果外部传入了 header 处理器，则执行外部逻辑 (比如注入 Token)
        if (this.config.headerHandler) {
          config = this.config.headerHandler(config);
        }
        // ====== 打印请求日志 ======
        console.warn(`[HTTP Request] START ------------------------------------------`);
        console.warn(`URL: ${config.baseURL || ''}${config.url}`);
        console.warn(`Method: ${config.method?.toUpperCase()}`);
        console.warn(`Headers: ${JSON.stringify(config.headers)}`);
        if (config.params) {
          console.warn(`Query Params: ${JSON.stringify(config.params)}`);
        }
        if (config.data) {
          console.warn(`Body Data: ${JSON.stringify(config.data)}`);
        }
        console.warn(`[HTTP Request] END --------------------------------------------`);
        // ========================

        return config;
      },
      (error: AxiosError) => {
        return Promise.reject(error);
      }
    );

    // --- 响应拦截器 ---
    this.axiosInstance.interceptors.response.use((response: AxiosResponse) => {
      // 1. 提取后端返回的数据
      const resData = response.data as BaseResponse<Any>;

      // ====== 打印响应日志 ======
      console.warn(`[HTTP Response] START -----------------------------------------`);
      console.warn(`URL: ${response.config.url}`); // 打印对应的请求URL，方便对照
      console.warn(`Code: ${resData.errorCode}`);
      // 打印完整的返回数据 (或者只打印 result，看你需求)
      console.warn(`Data: ${JSON.stringify(resData)}`);
      console.warn(`[HTTP Response] END -------------------------------------------`);
      // ========================

      // 检查 callback 是否存在
      if (this.config.onHeadersReceived && response.headers) {
        // 将响应的header 抛出去，让应用层能拿到header内容
        this.config.onHeadersReceived(response.headers as Record<string, Any>);
      }

      // 2. 业务状态码判断   0 代表成功
      if (resData.errorCode !== 0) {
        // 触发全局错误钩子
        if (this.config.errorHandler) {
          this.config.errorHandler(resData.errorCode, resData.errorMsg);
        }
        // 打印错误日志，方便调试
        console.error(`[HTTP Error] 业务异常: ${resData.errorMsg}`);
        ToastUtil.showShort(resData.errorMsg)
        // 抛出业务错误，中断流程
        return Promise.reject(new Error(resData.errorMsg || 'Unknown Error'));
      }
      // 3. 成功，直接返回完整对象
      return resData.data as Any as AxiosResponse;
    }, (error: AxiosError) => {
        // ====== 打印网络错误日志 ======
        console.error(`[HTTP Exception] START --------------------------------------`);
        console.error(`URL: ${error.config?.url}`);
        console.error(`Message: ${error.message}`);
        if (error.response) {
          console.error(`Status: ${error.response.status}`);
          console.error(`Response: ${JSON.stringify(error.response.data)}`);
        }
        console.error(`[HTTP Exception] END ----------------------------------------`);
        // ===========================
        // 处理 HTTP 层面错误 (如 404, 500, 网络超时)
        let errorMsg = '网络连接异常';
        if (error.response) {
          // 服务器有返回，但状态码非 2xx
          const status = error.response.status;
          switch (status) {
            case 404:
              errorMsg = '请求资源不存在';
              break;
            case 500:
              errorMsg = '服务器内部错误';
              break;
            case 502:
              errorMsg = '网关错误';
              break;
            // ... 其他状态码
          }
        } else if (error.message.includes('timeout')) {
          errorMsg = '请求超时';
        }

        // 触发全局错误钩子
        if (this.config.errorHandler) {
          // 使用 -1 或其他特定 code 代表 HTTP/网络层面的错误
          this.config.errorHandler(-1, errorMsg);
        }

        return Promise.reject(new Error(errorMsg));
      }
    );
  }

  /**
   * 工具方法：处理 URL 路径参数替换
   * 示例：formatUrl("/user/{id}", {id: 100}) -> "/user/100"
   */
  private formatUrl(url: string, pathParams?: Record<string, Any>): string {
    if (!pathParams || Object.keys(pathParams).length === 0) {
      return url;
    }

    let formattedUrl = url;
    Object.keys(pathParams).forEach((key) => {
      const value = String(pathParams[key]);
      // 替换 {key} 格式
      formattedUrl = formattedUrl.replace(new RegExp(`\\{${key}\\}`, 'g'), value);
      // 替换 :key 格式 (兼容某些后端风格)
      formattedUrl = formattedUrl.replace(new RegExp(`:${key}`, 'g'), value);
    });
    return formattedUrl;
  }

  /**
   * 通用请求方法 (被装饰器调用)
   * T: 响应数据中 result 的类型
   */
  public request<T>(options: RequestOptions): Promise<T> {
    // 1. 处理路径参数
    const finalUrl = this.formatUrl(options.url, options.pathParams);

    // 2. 组装 Axios 配置
    const config: AxiosRequestConfig = {
      url: finalUrl,
      method: options.method,
      params: options.queryParams, // GET 参数 (URL ?)
      data: options.data, // POST/PUT 参数 (Body)
    };

    // 3. 发起请求
    return new Promise((resolve, reject) => {
      this.axiosInstance.request<Any, T>(config)
        .then((res) => {
          resolve(res as Any as T);
        })
        .catch((error: AxiosError) => {
          reject(error);
        });
    });
  }
}

// 导出单例，方便装饰器文件直接引用
export const net = NetworkManager.getInstance();