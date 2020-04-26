const data = {
  el: '#page',
  data() {
  return {
    imageUrl: 'http://img2.ciurl.cn/flashsale/upload/xinfotek_upload/2016/10/13/1476341039744775.png'
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
