const data = {
  el: '#page',
  methods: {
  navigateBack() {
    Bridge.navigateBack()
  },
  navigateTo() {
    Bridge.navigateTo({
      url: '/pages/API/navigate-back/delta'
    })
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
