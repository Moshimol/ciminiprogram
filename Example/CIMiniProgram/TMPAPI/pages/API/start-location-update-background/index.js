const data = {
  el: '#page',
  methods: {
  startLocationUpdateBackground() {
    Bridge.startLocationUpdateBackground({
      success: (res) => {
        Bridge.showModal({
          content: '开启监听位置信息成功'
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
