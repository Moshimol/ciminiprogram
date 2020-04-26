const data = {
  el: '#page',
  data() {
  return {
    loading: false,
    duration: 2000,
    requestUrl: 'http://211.159.154.159/http/'
  }
},
methods: {
  makeRequest() {
    const self = this

    self.loading = true

    Bridge.request({
      url: this.requestUrl,
      data: {
        noncestr: Date.now()
      },
      success(result) {
        Bridge.showModal({
          showCancel: false,
          title: '请求成功',
          content: `返回数据为${result}`
        })
        self.loading = false
        console.log('request success', result)
      },

      fail({ errMsg }) {
        console.log('request fail', errMsg)
        self.loading = false
      }
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
