const data = {
  el: '#page',
  methods: {
  getSystemInfo() {
    Bridge.getSystemInfo({
      success(res) {
        Bridge.showModal({
          content: `
            设备型号: ${res.model}
            设备像素比: ${res.pixelRatio}
            可使用窗口宽度: ${res.windowWidth}
            可使用窗口高度: ${res.windowHeight}
            客户端平台: ${res.platform}
          `
        })
      }
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
