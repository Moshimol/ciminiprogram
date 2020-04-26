const data = {
  el: '#page',
  data() {
  return {
    showDialog: false,
    istrue: false
  }
},
methods: {
  open() {
    Bridge.showActionSheet({
      itemList: ['A', 'B', 'C'],
      success: function (res) {
        if (!res.cancel) {
          Bridge.showModal({
            showCancel: false,
            title: '获取缓存状态成功',
            content: res.tapIndex
          })
          console.log(res.tapIndex)
        }
      }
    })
  },
  openDialog() {
    this.istrue = true
  },
  closeDialog() {
    this.istrue = false
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
