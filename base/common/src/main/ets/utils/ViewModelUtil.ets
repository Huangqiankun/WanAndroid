import { HMRouterMgr, IHMLifecycle } from "@hadss/hmrouter";

// 定义一个通用的获取方法
export function getViewModel<T extends IHMLifecycle>(): T | undefined {
  const lifecycle = HMRouterMgr.getCurrentLifecycleOwner()?.getLifecycle();
  // 这里的类型转换在泛型约束下是安全的
  return lifecycle as T;
}
