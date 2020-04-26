const data = {
  el: '#page',
  methods: {
  async removeStorageSync() {
    await Bridge.removeStorageSync('testKey')
    Bridge.showModal({
      showCancel: false,
      title: '删除数据成功',
      content: ``
    })
  }
},
onload() {
  Bridge.setStorage({
    key: 'testKey',
    value: 'testValue'
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
