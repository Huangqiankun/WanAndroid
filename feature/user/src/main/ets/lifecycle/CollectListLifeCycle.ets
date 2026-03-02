import { HMLifecycle, HMLifecycleContext, IHMLifecycle } from "@hadss/hmrouter";
import { Any, LogUtil, RefreshController, ToastUtil } from "common";
import { CollectListResult, CollectListResultDatas } from "../model/UserReponseResult";
import { UserApi } from "../net/UserApi";

@ObservedV2
@HMLifecycle({ lifecycleName: CollectListLifeCycle.lifeCycleName })
export class CollectListLifeCycle implements IHMLifecycle {
  static readonly lifeCycleName = "CollectListLifeCycle"
  @Trace listArticle: CollectListResultDatas[] = []
  @Trace hasMore: boolean = true;
  //------------------------- 以下变量仅限 collectArticleList2 方法调用-----------------
  // 定义请求结果状态
  @Trace loadStatus: 'IDLE' | 'LOADING' | 'SUCCESS' | 'FAILED' = 'IDLE';
  // 用于触发监听的自增种子（如果状态值没变，但请求结束了，靠它触发 UI）
  @Trace requestTrigger: number = 0;

  @Trace page: number = 0
  //------------------------- 以上变量仅限 collectArticleList2 方法调用-----------------

  onShown(ctx: HMLifecycleContext): void {
    this.page=0
    this.collectArticleList2()
  }
  /**
   * 该方法 通过 onFinished 触发 UI
   * @param page
   * @param onFinished
   */
  collectArticleList(onFinished?: (success: boolean, hasMore: boolean) => void) {
    UserApi.getCollectList(this.page).then((collectList: CollectListResult) => {
      if (this.page == 0) {
        this.listArticle = collectList.datas
      } else {
        this.listArticle = this.listArticle.concat(collectList.datas)
      }
      this.hasMore = collectList.curPage < collectList.pageCount;
      onFinished?.(true, this.hasMore)
    }).catch((error: Any) => {
      onFinished?.(false, true)
      ToastUtil.showShort(error?.toString())
    })
  }


  /**
   * 该方法 通过 requestTrigger+@Monitor 触发 UI
   * @param page
   */
  collectArticleList2() {
    this.loadStatus = 'LOADING'
    UserApi.getCollectList(this.page).then((collectList: CollectListResult) => {
      if (this.page == 0) {
        this.listArticle = collectList.datas
      } else {
        this.listArticle = this.listArticle.concat(collectList.datas)
      }
      this.hasMore = collectList.curPage < collectList.pageCount;
      this.loadStatus = 'SUCCESS';
    }).catch((error: Any) => {
      this.loadStatus = 'FAILED';
      ToastUtil.showShort(error?.toString())
    }).finally(() => {
      this.requestTrigger++; // 每次请求结束自增，确保 Monitor 能抓到
    })
  }

}