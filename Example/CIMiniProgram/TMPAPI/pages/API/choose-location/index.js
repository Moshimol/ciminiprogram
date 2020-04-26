const data = {
  el: '#page',
  methods: {
  chooseLocation() {
    Bridge.chooseLocation({
      success: (res) => {
        Bridge.showModal({
          content: `选择的位置名称为: ${res.name};详细地址为: ${res.address}`
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
