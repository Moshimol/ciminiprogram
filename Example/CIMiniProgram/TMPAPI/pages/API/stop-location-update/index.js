const data = {
  el: '#page',
  methods: {
  stopLocationUpdate() {
    Bridge.stopLocationUpdate({
      success: (res) => {
        Bridge.showModal({
          content: '关闭监听位置信息成功'
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
