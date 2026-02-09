import { Any } from '@pura/harmony-utils';
import { net, RequestOptions } from '../core/NetworkManager';


// 2. 定义参数类型枚举 (保持不变)
enum ParamType {
  PATH = 'PATH',
  QUERY = 'QUERY',
  BODY = 'BODY'
}

// 3. 定义参数元数据结构 (保持不变)
interface ParamMetadata {
  key: string; // 参数名
  index: number; // 参数位置
  type: ParamType; // 参数类型
}

/**
 * 元数据仓库
 * 结构：Target(Class原型) -> MethodName(方法名) -> MetadataList(参数列表)
 * 使用 WeakMap 防止内存泄漏，当类被销毁时元数据自动释放
 */
const metadataStorage = new WeakMap<Object, Map<string, ParamMetadata[]>>();

/**
 * 辅助函数：获取指定方法的所有参数元数据
 * 如果不存在，则初始化一个空数组
 */
function getParamsMetadata(target: Object, propertyKey: string): ParamMetadata[] {
  // 1. 获取该类的元数据 Map
  let classMeta = metadataStorage.get(target);
  if (!classMeta) {
    classMeta = new Map<string, ParamMetadata[]>();
    metadataStorage.set(target, classMeta);
  }

  // 2. 获取该方法的元数据数组
  let methodMeta = classMeta.get(propertyKey);
  if (!methodMeta) {
    methodMeta = [];
    classMeta.set(propertyKey, methodMeta);
  }

  return methodMeta;
}

// ----------------------------------------

/**
 * 4. 参数装饰器工厂 (替代 @Path, @Query)
 * 原理：将参数信息存入上面的 metadataStorage
 */
const createParamDecorator = (type: ParamType) => {
  return (key?: string) => {
    return (target: Object, propertyKey: string, parameterIndex: number) => {
      // A. 获取该方法的元数据列表 (替换 Reflect.getOwnMetadata)
      const existingParameters = getParamsMetadata(target, propertyKey);

      // B. 存入新参数信息
      existingParameters.push({
        key: key || '',
        index: parameterIndex,
        type: type,
      });

      // C. 无需手动 save，因为 getParamsMetadata 返回的是引用，直接 push 就已经存进 Map 了
    };
  };
};

// 导出具体的参数装饰器 (用法不变)
export const Path = createParamDecorator(ParamType.PATH);

export const Query = createParamDecorator(ParamType.QUERY);

export const Body = createParamDecorator(ParamType.BODY)();


/**
 * 5. 方法装饰器工厂 (替代 @GET, @POST)
 * 原理：从 metadataStorage 读取信息并发起请求
 */
const createMethodDecorator = (method: string) => {
  return (url: string) => {
    return (target: Object, propertyKey: string, descriptor: PropertyDescriptor) => {
      // 保留原始方法（虽然不执行，但保持结构）
      const originalMethod: Any = descriptor.value;

      // --- 核心逻辑：重写方法体 ---
      descriptor.value = async (...args: Any[]) => {

        // A. 读取元数据 (替换 Reflect.getOwnMetadata)
        const paramsMetadata = getParamsMetadata(target, propertyKey);

        // B. 准备请求容器
        const pathParams: Record<string, Any> = {};
        const queryParams: Record<string, Any> = {};
        let bodyData: Any = null;

        // C. 遍历元数据，从 args 中取值
        paramsMetadata.forEach((meta) => {
          const value = args[meta.index]; // 获取运行时传入的实参
          // D. 将对应类型的参数，放入对应类型的容器里面
          if (meta.type === ParamType.PATH) {
            pathParams[meta.key] = value;
          } else if (meta.type === ParamType.QUERY) {
            queryParams[meta.key] = value;
          } else if (meta.type === ParamType.BODY) {
            bodyData = value;
          }
        });

        // E. 组装 Options
        const options: RequestOptions = {
          url,
          method,
          pathParams,
          queryParams,
          data: bodyData
        };

        // F. 发起请求
        return await net.request<Any>(options);
      };

      return descriptor;
    };
  };
};

// 导出具体的方法装饰器 (用法不变)
export const GET = createMethodDecorator('GET');

export const POST = createMethodDecorator('POST');

export const PUT = createMethodDecorator('PUT');

export const DELETE = createMethodDecorator('DELETE');