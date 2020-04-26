const data = {
  el: '#page',
  methods: {
  async getStorageSync() {
    try {
      const value = await Bridge.getStorageSync('testKey')
      Bridge.showModal({
        showCancel: false,
        title: '获取数据成功',
        content: `testKey: ${value}`
      })
    } catch (error) {
      Bridge.showModal({
        showCancel: false,
        title: '获取数据失败',
        content: error
      })
    }
  }
},
onLoad() {
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
