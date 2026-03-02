import { HMRouter } from "@hadss/hmrouter"
import { ProductPhonePath } from "common"
import { SplashLifeCycle } from "../lifecycle/SplashLifeCycle"

@HMRouter({ pageUrl: ProductPhonePath.LOADING, lifecycle: SplashLifeCycle.lifeCycleName, singleton: true })
@ComponentV2
@Preview
export struct SplashPage {
  build() {
    RelativeContainer() {
      Image($r('app.media.phone_loading')).width('100%').height('100%').onClick(() => {

      })
    }
    .height('100%')
    .width('100%')
  }
}