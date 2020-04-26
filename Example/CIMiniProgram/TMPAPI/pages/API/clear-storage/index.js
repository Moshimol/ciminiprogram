const data = {
  el: '#page',
  data() {
  return {
    loading: false
  }
},
methods: {
  clearStorage() {
    this.loading = true
    Bridge.clearStorage({
      success: () => {
        Bridge.showModal({
          showCancel: false,
          title: '清除数据成功',
          content: ''
        })
      },
      fail: () => {
        Bridge.showModal({
          showCancel: false,
          title: '清除数据失败',
          content: ''
        })
      },
      complete: () => {
        this.loading = false
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
