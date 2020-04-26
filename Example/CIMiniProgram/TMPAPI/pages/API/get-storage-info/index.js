const data = {
  el: '#page',
  methods: {
  getStorageInfo() {
    Bridge.getStorageInfo({
      success: (res) => {
        Bridge.showModal({
          showCancel: false,
          title: '获取缓存状态成功',
          content: `
          keys: ${res.keys},
          currentSize: ${res.currentSize},
          limitSize: ${res.limitSize}
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
