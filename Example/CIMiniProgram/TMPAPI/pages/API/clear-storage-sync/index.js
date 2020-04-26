const data = {
  el: '#page',
  data() {
  return {
    loading: false
  }
},
methods: {
  clearStorageSync() {
    this.loading = true
    Bridge.showModal({
      showCancel: false,
      title: '开始清除数据',
      content: ''
    })
    try {
      Bridge.clearStorageSync()
      Bridge.showModal({
        showCancel: false,
        title: '清除数据成功',
        content: ''
      })
    } catch (error) {
      Bridge.showModal({
        showCancel: false,
        title: '清除数据失败',
        content: ''
      })
    }
    Bridge.showModal({
      showCancel: false,
      title: '清除数据结束',
      content: ''
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
