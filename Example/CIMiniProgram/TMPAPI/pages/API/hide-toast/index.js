const data = {
  el: '#page',
  methods: {
  toastTap() {
    Bridge.showToast({
      title: '默认',
      duration: 20000
    })
  },
  hideToast() {
    Bridge.hideToast()
  }
}
}

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
