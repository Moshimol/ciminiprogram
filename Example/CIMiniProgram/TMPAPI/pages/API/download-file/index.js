const data = {
  el: '#page',
  data() {
  return {
    imageSrc: ''
  }
},
methods: {
  downloadFile() {
    Bridge.downloadFile({
      url: 'http://192.168.2.228/dist.zip',
      success(res) {
        console.log('downloadFile success, res is', res)

        this.imageSrc = res.tempFilePath
      },
      fail({errMsg}) {
        console.log('downloadFile fail, err is:', errMsg)
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
