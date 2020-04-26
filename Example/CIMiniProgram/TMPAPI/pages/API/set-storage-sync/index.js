const data = {
  el: '#page',
  methods: {
  async setStorageSync() {
    await Bridge.setStorageSync('testKey', 'testValue')
    Bridge.showModal({
      showCancel: false,
      title: '缓存数据成功',
      content: ``
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
