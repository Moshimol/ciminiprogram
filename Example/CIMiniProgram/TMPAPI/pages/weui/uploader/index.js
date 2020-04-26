const data = {
  el: '#page',
  data() {
  return {
    files: []
  }
},
methods: {
  chooseImage(e) {
    var that = this;
    Bridge.chooseImage({
      sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
      sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
      success: function (res) {
        // 返回选定照片的本地文件路径列表，tempFilePath可以作为img标签的src属性显示图片
        that.files = that.files.concat(res.tempFilePaths)
      }
    })
  },
  previewImage(e){
    Bridge.previewImage({
      current: e.currentTarget.id, // 当前显示图片的http链接
      urls: this.files // 需要预览的图片http链接列表
    })
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
