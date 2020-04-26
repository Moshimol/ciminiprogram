const data = {
  el: '#page',
  methods: {
  toast1Tap() {
    Bridge.showToast({
      title: '默认'
    })
  },

  toast2Tap() {
    Bridge.showToast({
      title: 'duration 3000',
      duration: 3000
    })
  },

  toast3Tap() {
    Bridge.showToast({
      title: 'loading',
      icon: 'loading',
      duration: 5000
    })
  },

  hideToast() {
    Bridge.hideToast()
  },

  showCustomImage() {
    Bridge.showToast({
      title: '自定义图标',
      image: '/assets/api.png'
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
