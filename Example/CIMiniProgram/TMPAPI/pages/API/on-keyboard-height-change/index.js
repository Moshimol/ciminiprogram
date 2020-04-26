const data = {
  el: '#page',
  created() {
  Bridge.onKeyboardHeightChange(res => {
    Bridge.showModal({
      content: `键盘高度：${res.height}`
    })
  })
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
