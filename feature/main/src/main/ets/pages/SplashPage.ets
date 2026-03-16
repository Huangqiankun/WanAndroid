import { HMRouter } from "@hadss/hmrouter"
import { FeatureMainPath, ProductPhonePath } from "common"
import { SplashLifeCycle } from "../lifecycle/SplashLifeCycle"

@HMRouter({ pageUrl: FeatureMainPath.LOADING, lifecycle: SplashLifeCycle.lifeCycleName, singleton: true })
@ComponentV2
@Preview
export struct SplashPage {
  build() {
    RelativeContainer() {
      Image($r('app.media.main_loading')).width('100%').height('100%').onClick(() => {

      })
    }
    .height('100%')
    .width('100%')
  }
}