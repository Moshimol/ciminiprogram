const data = {
  el: '#page',
  methods: {
  getSystemInfoSync() {
    const info = Bridge.getSystemInfoSync()
    Bridge.showModal({
      content: `
        设备型号: ${info.model}
        设备像素比: ${info.pixelRatio}
        可使用窗口宽度: ${info.windowWidth}
        可使用窗口高度: ${info.windowHeight}
        客户端平台: ${info.platform}
      `
    })
  }
}}

const lifeCycle = ['onReady', 'onShow', 'onHide']

class Page {
  constructor(data) {
    this.vueIns = new Vue(data)
    lifeCycle.forEach(hook => {
      data[hook] && ( this[hook] = data[hook].bind(this.vueIns) )
    })
  }
}
const pageIns = new Page(data)
window.pageIns = pageIns
