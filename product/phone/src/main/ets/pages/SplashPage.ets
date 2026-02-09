import { HMRouter } from "@hadss/hmrouter"
import { ProductPhonePath } from "common"

@HMRouter({ pageUrl: ProductPhonePath.LOADING, lifecycle: "SplashLifeCycle", singleton: true })
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