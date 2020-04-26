const data = {
  el: '#page',
  methods: {
  openToast() {
    Bridge.showToast({
      title: '已完成',
      icon: 'success',
      duration: 3000
    });
  },
  openLoading() {
    Bridge.showToast({
      title: '数据加载中',
      icon: 'loading',
      duration: 3000
    });
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
