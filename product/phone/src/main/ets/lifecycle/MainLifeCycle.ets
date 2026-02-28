import { HMLifecycle, HMLifecycleContext, HMRouterMgr, IHMLifecycle } from "@hadss/hmrouter";
import { Any, LogUtil } from "common";


@HMLifecycle({ lifecycleName: "MainLifeCycle" })
export class MainLifeCycle implements IHMLifecycle {
  onPrepare(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onPrepare")
  }

  onWillAppear(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onWillAppear")
  }

  onReady(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onReady")
  }


  onAppear(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onAppear")
  }

  onWillShow(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onWillShow")
  }

  onShown(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onShown" + JSON.stringify(HMRouterMgr.getCurrentParam()))
  }

  onActive(ctx: HMLifecycleContext, activeReason?: NavDestinationActiveReason | undefined): void {
    LogUtil.debug("MainLifeCycle onActive")
  }

  onWillHide(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onWillHide")
  }

  onInactive(ctx: HMLifecycleContext, inactiveReason?: NavDestinationActiveReason | undefined): void {
    LogUtil.debug("MainLifeCycle onInactive")
  }

  onHidden(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onHidden")
  }

  onWillDisappear(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onWillDisappear")
  }

  onDisAppear(ctx: HMLifecycleContext): void {
    LogUtil.debug("MainLifeCycle onDisAppear")
  }

  onResult(ctx: HMLifecycleContext, result?: ESObject): void {
    LogUtil.debug("MainLifeCycle onResult" + JSON.stringify(result))
  }

  onNewParam(ctx: HMLifecycleContext, newParam?: ESObject): void {
    LogUtil.debug("MainLifeCycle onNewParam" + JSON.stringify(newParam))
  }

  onBackPressed(ctx: HMLifecycleContext): boolean {
    LogUtil.debug("MainLifeCycle onBackPressed")
    return false
  }
}