const data = {
  el: '#page',
  methods: {
  getSelectedTextRange() {
    Bridge.getSelectedTextRange({
      successL: (res) => {
        Bridge.showModal({
          content: `开始位置：${res.start};结束位置：${res.end}`
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
