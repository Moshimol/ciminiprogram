class RequestTask {
  constructor(id) {
    this.id = id
  }
  abort() { }
  onHeadersReceived(callback) { }
  offHeadersReceived() { }
}

class SocketTask {
  constructor(id, url, protocols) {
    this.socketInstance = new WebSocket(url, protocols)
    this.socketInstance.onclose = () => { }
    this.socketInstance.onerror = () => { }
    this.socketInstance.onmessage = () => { }
    this.socketInstance.onopen = () => { }
    this.id = id
  }
  async close({ code = 1000, reason, success = () => { }, fail = () => { }, complete = () => { } }) {
    try {
      this.socketInstance.close(code, reason || '')
      await success()
    } catch (error) {
      await fail()
    }
    await complete()
  }
  async send({ data, success = () => { }, fail = () => { }, complete = () => { } }) {
    try {
      this.socketInstance.send(data)
      await success()
    } catch (error) {
      await fail()
    }
    await complete()
  }
  onClose(callback) {
    this.socketInstance.onclose = (e) => {
      callback({
        code: e.code || 1000,
        reason: e.reason || ''
      })
    }

  }
  onError(callback) {
    this.socketInstance.onerror = callback
  }
  onMessage(callback) {
    this.socketInstance.onmessage = callback
  }
  onOpen(callback) {
    this.socketInstance.onopen = callback
  }
}

class SocketTaskManager {
  constructor() {
    this.socketTasks = []
  }
  add(socketTask) {
    this.socketTasks.push(socketTask)
  }
  getIndexById(id) {
    return this.socketTasks.findIndex(item => `${item.id}` === `${id}`)
  }
  getFirst() {
    return this.socketTasks[0] || null
  }
  getById(id) {
    const index = this.getIndexById(id)
    return index !== -1 ? this.socketTasks[index] : null
  }
  remove(id) {
    const index = this.getIndexById(id)
    return index !== -1 ? this.socketTasks.splice(index, 1) : null
  }
  clear() {
    this.socketTasks = []
  }
}

const socketTaskManager = new SocketTaskManager()

const parseQueryString = (querystring) => {
  const params = {}
  if (!querystring) {
    return params
  }
  const arr = querystring.split('&')
  for (let i = 0; i < arr.length; i++) {
    let a = arr[i].split('=')
    params[a[0]] = a[1]
  }
  return params
}

const stringifyQueryString = (obj) => {

}

const checkHexColor = (value) => {
  return /^\#[0-9a-fA-F]{3}$/.test(value) || /^\#[0-9a-fA-F]{6}$/.test(value)
}

const validateUrl = (url) => {
  return /^(http|https):\/\/.*/i.test(url)
}

const urlEncodeFormData = (data) => {//把对象生成queryString
  const needEncode = arguments.length > 1 && void 0 !== arguments[1] && arguments[1]
  if ('object' !== typeof (data)) {
    return data
  }
  const tmpArr = []
  for (let o in data) if (data.hasOwnProperty(o)) {
    if (needEncode) {
      try {
        tmpArr.push(encodeURIComponent(o) + '=' + encodeURIComponent(data[o]))
      } catch (t) {
        tmpArr.push(o + '=' + data[o])
      }
    } else tmpArr.push(o + '=' + data[o])

  }
  return tmpArr.join('&')
}

const addQueryStringToUrl = (originalUrl, newParams) => {//生成url t:param obj
  if ('string' == typeof originalUrl && 'object' === typeof (newParams) && Object.keys(newParams).length > 0) {
    const urlComponents = originalUrl.split('?')
    const host = urlComponents[0]
    const oldParams = (urlComponents[1] || '').split('&').reduce(function (res, cur) {
      if ('string' == typeof cur && cur.length > 0) {
        const curArr = cur.split('=')
        const key = curArr[0]
        const value = curArr[1]
        res[key] = value
      }
      return res
    }, {})
    const refinedNewParams = Object.keys(newParams).reduce(function (res, cur) {
      'object' === typeof (newParams[cur]) ?
        res[encodeURIComponent(cur)] = encodeURIComponent(JSON.stringify(newParams[cur])) :
        res[encodeURIComponent(cur)] = encodeURIComponent(newParams[cur])
      return res
    }, {})
    return host + '?' + urlEncodeFormData(Object.assign(oldParams, refinedNewParams))
  }
  return originalUrl
}

const APIs = {
  getSystemInfoSync: {
    '1.0.0': {
      params: [],
      returnProperty: [
        {
          type: 'object',
          schema: [
            {
              name: 'brand',
              type: 'string'
            },
            {
              name: 'model',
              type: 'string'
            },
            {
              name: 'pixelRatio',
              type: 'number'
            },
            {
              name: 'screenWidth',
              type: 'number'
            },
            {
              name: 'screenHeight',
              type: 'number'
            },
            {
              name: 'windowWidth',
              type: 'number'
            },
            {
              name: 'windowHeight',
              type: 'number'
            },
            {
              name: 'statusBarHeight',
              type: 'number'
            },
            {
              name: 'language',
              type: 'string'
            },
            {
              name: 'version',
              type: 'string'
            },
            {
              name: 'system',
              type: 'string'
            },
            {
              name: 'platform',
              type: 'string'
            },
            {
              name: 'fontSizeSetting',
              type: 'number'
            },
            {
              name: 'SDKVersion',
              type: 'string'
            },
            {
              name: 'benchmarkLevel',
              type: 'number'
            },
            {
              name: 'albumAuthorized',
              type: 'boolean'
            },
            {
              name: 'cameraAuthorized',
              type: 'boolean'
            },
            {
              name: 'locationAuthorized',
              type: 'boolean'
            },
            {
              name: 'microphoneAuthorized',
              type: 'boolean'
            },
            {
              name: 'notificationAuthorized',
              type: 'boolean'
            },
            {
              name: 'notificationAlertAuthorized',
              type: 'boolean'
            },
            {
              name: 'notificationBadgeAuthorized',
              type: 'boolean'
            },
            {
              name: 'notificationSoundAuthorized',
              type: 'boolean'
            },
            {
              name: 'bluetoothEnabled',
              type: 'boolean'
            },
            {
              name: 'locationEnabled',
              type: 'boolean'
            },
            {
              name: 'wifiEnabled',
              type: 'boolean'
            },
            {
              name: 'safeArea',
              type: 'object',
              schema: [
                {
                  name: 'left',
                  type: 'number'
                },
                {
                  name: 'right',
                  type: 'number'
                },
                {
                  name: 'top',
                  type: 'number'
                },
                {
                  name: 'bottom',
                  type: 'number'
                },
                {
                  name: 'width',
                  type: 'number'
                },
                {
                  name: 'height',
                  type: 'number'
                },
              ]
            },

          ]
        }
      ]
    }
  },
  getSystemInfo: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'brand',
                      type: 'string'
                    },
                    {
                      name: 'model',
                      type: 'string'
                    },
                    {
                      name: 'pixelRatio',
                      type: 'number'
                    },
                    {
                      name: 'screenWidth',
                      type: 'number'
                    },
                    {
                      name: 'screenHeight',
                      type: 'number'
                    },
                    {
                      name: 'windowWidth',
                      type: 'number'
                    },
                    {
                      name: 'windowHeight',
                      type: 'number'
                    },
                    {
                      name: 'statusBarHeight',
                      type: 'number'
                    },
                    {
                      name: 'language',
                      type: 'string'
                    },
                    {
                      name: 'version',
                      type: 'string'
                    },
                    {
                      name: 'system',
                      type: 'string'
                    },
                    {
                      name: 'platform',
                      type: 'string'
                    },
                    {
                      name: 'fontSizeSetting',
                      type: 'number'
                    },
                    {
                      name: 'SDKVersion',
                      type: 'string'
                    },
                    {
                      name: 'benchmarkLevel',
                      type: 'number'
                    },
                    {
                      name: 'albumAuthorized',
                      type: 'boolean'
                    },
                    {
                      name: 'cameraAuthorized',
                      type: 'boolean'
                    },
                    {
                      name: 'locationAuthorized',
                      type: 'boolean'
                    },
                    {
                      name: 'microphoneAuthorized',
                      type: 'boolean'
                    },
                    {
                      name: 'notificationAuthorized',
                      type: 'boolean'
                    },
                    {
                      name: 'notificationAlertAuthorized',
                      type: 'boolean'
                    },
                    {
                      name: 'notificationBadgeAuthorized',
                      type: 'boolean'
                    },
                    {
                      name: 'notificationSoundAuthorized',
                      type: 'boolean'
                    },
                    {
                      name: 'bluetoothEnabled',
                      type: 'boolean'
                    },
                    {
                      name: 'locationEnabled',
                      type: 'boolean'
                    },
                    {
                      name: 'wifiEnabled',
                      type: 'boolean'
                    },
                    {
                      name: 'safeArea',
                      type: 'object',
                      schema: [
                        {
                          name: 'left',
                          type: 'number'
                        },
                        {
                          name: 'right',
                          type: 'number'
                        },
                        {
                          name: 'top',
                          type: 'number'
                        },
                        {
                          name: 'bottom',
                          type: 'number'
                        },
                        {
                          name: 'width',
                          type: 'number'
                        },
                        {
                          name: 'height',
                          type: 'number'
                        },
                      ]
                    },

                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  closeProgram: {
    '1.0.0': {
      params: []
    }
  },
  showToast: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'title',
              type: 'string',
              required: true
            },
            {
              name: 'icon',
              type: 'enum',
              schema: [{
                type: 'string'
              }],
              default: 'success',
              validValues: [
                'success',
                'loading',
                'none'
              ]
            },
            {
              name: 'image',
              type: 'string'
            },
            {
              name: 'duration',
              type: 'number',
              default: 1500
            },
            {
              name: 'mask',
              type: 'boolean',
              default: false
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  showModal: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'title',
              type: 'string'
            },
            {
              name: 'content',
              type: 'string'
            },
            {
              name: 'showCancel',
              type: 'boolean',
              default: true
            },
            {
              name: 'cancelText',
              type: 'string',
              default: '取消'
            },
            {
              name: 'cancelColor',
              type: 'string',
              default: '#000000'
            },
            {
              name: 'confirmText',
              type: 'string',
              default: '确定'
            },
            {
              name: 'confirmColor',
              type: 'string',
              default: '#576B95'
            },
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'confirm',
                      type: 'boolean'
                    },
                    {
                      name: 'cancel',
                      type: 'boolean'
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  showLoading: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'title',
              type: 'string',
              required: true
            },
            {
              name: 'mask',
              type: 'boolean',
              default: false
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  showActionSheet: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'itemList',
              type: 'array',
              schema: [
                {
                  type: 'string'
                }
              ],
              required: true
            },
            {
              name: 'itemColor',
              type: 'string',
              default: '#000000'
            },
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'tapIndex',
                      type: 'number'
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  hideLoading: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  switchTab: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'url',
              type: 'string',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  reLaunch: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'url',
              type: 'string',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  redirectTo: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'url',
              type: 'string',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  navigateTo: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'url',
              type: 'string',
              required: true
            },
            {
              name: 'events',
              type: 'object'
            },
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [{
                    name: 'eventChannel',
                    type: 'object'
                  }]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  navigateBack: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'delta',
              type: 'number',
              default: 1
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  showNavigationBarLoading: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  setNavigationBarTitle: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'title',
              type: 'string',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  setNavigationBarColor: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'frontColor',
              type: 'enum',
              schema: [{
                type: 'string'
              }],
              validValues: [
                '#ffffff',
                '#000000'
              ],
              required: true
            },
            {
              name: 'backgroundColor',
              type: 'string',
              required: true,
              customFunc: checkHexColor
            },
            {
              name: 'animation',
              type: 'object',
              schema: [
                {
                  name: 'duration',
                  type: 'number',
                  default: 0
                },
                {
                  name: 'timingFunc',
                  type: 'enum',
                  default: 'linear',
                  schema: [
                    {
                      type: 'string'
                    }
                  ],
                  validValues: [
                    'linear',
                    'easeIn',
                    'easeOut',
                    'easeInOut'
                  ]
                }
              ]
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  hideNavigationBarLoading: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  setBackgroundColor: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'backgroundColor',
              type: 'string'
            },
            {
              name: 'backgroundColorTop',
              type: 'string'
            },
            {
              name: 'backgroundColorBottom',
              type: 'string'
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  setBackgroundTextStyle: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'textStyle',
              type: 'string',
              required: true,
              validValues: [
                'dark',
                'light'
              ],
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  showTabBarRedDot: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'index',
              type: 'number',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  showTabBar: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'animation',
              type: 'boolean',
              default: false
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  setTabBarStyle: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'color',
              type: 'string',
              customFunc: checkHexColor
            },
            {
              name: 'selectedColor',
              type: 'string',
              customFunc: checkHexColor
            },
            {
              name: 'backgroundColor',
              type: 'string',
              customFunc: checkHexColor
            },
            {
              name: 'borderStyle',
              type: 'enum',
              schema: [
                {
                  type: 'string'
                }
              ],
              validValues: [
                'black',
                'white'
              ]
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  setTabBarItem: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'index',
              type: 'number',
              required: true
            },
            {
              name: 'text',
              type: 'string'
            },
            {
              name: 'iconPath',
              type: 'string'
            },
            {
              name: 'selectedIconPath',
              type: 'string'
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  setTabBarBadge: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'index',
              type: 'number',
              required: true
            },
            {
              name: 'text',
              type: 'string',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  removeTabBarBadge: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'index',
              type: 'number',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  hideTabBarRedDot: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'index',
              type: 'number',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  hideTabBar: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'animation',
              type: 'boolean',
              default: false
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  stopPullDownRefresh: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  startPullDownRefresh: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  pageScrollTo: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'scrollTop',
              type: 'number'
            },
            {
              name: 'duration',
              type: 'number',
              default: 300
            },
            {
              name: 'selector',
              type: 'string'
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  nextTick: {
    '1.0.0': {
      params: [
        {
          type: 'function'
        }
      ]
    }
  },
  onKeyboardHeightChange: {
    '1.0.0': {
      params: [
        {
          type: 'function',
          returnProperty: [
            {
              type: 'object',
              schema: [
                {
                  name: 'height',
                  type: 'number'
                }
              ]
            }
          ]
        }
      ]
    }
  },
  hideKeyboard: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  getSelectedTextRange: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'start',
                      type: 'number'
                    },
                    {
                      name: 'end',
                      type: 'number'
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  request: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'url',
              type: 'string',
              required: true,
              customFunc: validateUrl
            },
            {
              name: 'data',
              type: [
                {
                  type: 'string'
                },
                {
                  type: 'object'
                },
                {
                  type: 'arrayBuffer'
                }
              ]
            },
            {
              name: 'header',
              type: 'object',
              schema: [
                {
                  name: 'content-type',
                  type: 'string',
                  default: 'application/json'
                },
                {
                  name: 'Referer',
                  type: 'string',
                  customFunc: () => {
                    return false
                  }
                }
              ]
            },
            {
              name: 'timeout',
              type: 'number'
            },
            {
              name: 'method',
              type: 'enum',
              schema: [{
                type: 'string'
              }],
              default: 'GET',
              validValues: [
                'OPTIONS',
                'GET',
                'HEAD',
                'POST',
                'PUT',
                'DELETE',
                'TRACE',
                'CONNECT'
              ]
            },
            {
              name: 'dataType',
              type: 'enum',
              schema: [{
                type: 'string'
              }],
              default: 'json',
              validValues: [
                'xml',
                'html',
                'script',
                'json',
                'jsonp',
                'text'
              ]
            },
            {
              name: 'responseType',
              type: 'enum',
              schema: [{
                type: 'string'
              }],
              default: 'text',
              validValues: [
                'text',
                'arraybuffer'
              ]
            },
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'data',
                      type: [
                        {
                          type: 'string'
                        },
                        {
                          type: 'object'
                        },
                        {
                          type: 'arrayBuffer'
                        }
                      ]
                    },
                    {
                      name: 'statusCode',
                      type: 'number'
                    },
                    {
                      name: 'header',
                      type: 'object'
                    },
                    {
                      name: 'cookie',
                      type: 'array',
                      schema: [
                        {
                          type: 'string'
                        }
                      ]
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  sendSocketMessage: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'data',
              required: true,
              type: [
                {
                  type: 'string'
                },
                {
                  type: 'arrayBuffer'
                }
              ]
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  onSocketOpen: {
    '1.0.0': {
      params: [
        {
          type: 'function',
          returnProperty: [
            {
              type: 'object',
              schema: [
                {
                  name: 'header',
                  type: 'object'
                }
              ]
            }
          ]
        }
      ]
    }
  },
  onSocketMessage: {
    '1.0.0': {
      params: [
        {
          type: 'function',
          returnProperty: [
            {
              type: 'object',
              schema: [
                {
                  name: 'data',
                  type: [
                    {
                      type: 'string'
                    },
                    {
                      type: 'arrayBuffer'
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  },
  onSocketError: {
    '1.0.0': {
      params: [
        {
          type: 'function',
          returnProperty: [
            {
              type: 'object',
              schema: [
                {
                  name: 'errMsg',
                  type: 'string'
                }
              ]
            }
          ]
        }
      ]
    }
  },
  onSocketClose: {
    '1.0.0': {
      params: [
        {
          type: 'function',
          returnProperty: [
            {
              type: 'object',
              schema: [
                {
                  name: 'code',
                  type: 'number'
                },
                {
                  name: 'reason',
                  type: 'string'
                }
              ]
            }
          ]
        }
      ]
    }
  },
  connectSocket: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'url',
              type: 'string',
              required: true
            },
            {
              name: 'header',
              type: 'object',
              schema: [
                {
                  name: 'Referer',
                  type: 'string',
                  customFunc: () => {
                    return false
                  }
                }
              ]
            },
            {
              name: 'protocols',
              type: 'array',
              schema: [{
                type: 'string'
              }]
            },
            {
              name: 'tcpNoDelay',
              type: 'boolean',
              default: false
            },
            {
              name: 'perMessageDeflate',
              type: 'boolean',
              default: false
            },
            {
              name: 'timeout',
              type: 'number'
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  closeSocket: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'code',
              type: 'number'
            },
            {
              name: 'reason',
              type: 'string'
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  downloadFile: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'url',
              type: 'string',
              required: true
            },
            {
              name: 'header',
              type: 'object'
            },
            {
              name: 'fielPath',
              type: 'string'
            },
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'tempFilePath',
                      type: 'string'
                    },
                    {
                      name: 'filePath',
                      type: 'string'
                    },
                    {
                      name: 'statusCode',
                      type: 'number'
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  uploadFile: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'url',
              type: 'string',
              required: true
            },
            {
              name: 'filePath',
              type: 'string',
              required: true
            },
            {
              name: 'name',
              type: 'string',
              required: true
            },
            {
              name: 'header',
              type: 'object'
            },
            {
              name: 'formData',
              type: 'object'
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  saveImageToPhotosAlbum: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'filePath',
              type: 'string',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  scanCode: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'onlyFromCamera',
              type: 'boolean',
              default: false
            },
            {
              name: 'scanType',
              type: 'array',
              default: ['barCode', 'qrCode'],
              schema: [
                {
                  type: 'enum',
                  schema: [
                    {
                      type: 'string'
                    }
                  ],
                  validValues: [
                    'barCode',
                    'qrCode',
                    'datamatrix',
                    'pdf417'
                  ]
                }
              ]
            },
            {
              name: 'success',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'result',
                      type: 'string'
                    },
                    {
                      name: 'scanType',
                      type: 'enum',
                      schema: [
                        {
                          type: 'string'
                        }
                      ],
                      validValues: [
                        'QR_CODE',
                        'AZTEC',
                        'CODABAR',
                        'CODE_39',
                        'CODE_93',
                        'CODE_128',
                        'DATA_MATRIX',
                        'EAN_8',
                        'EAN_13',
                        'ITF',
                        'MAXICODE',
                        'PDF_417',
                        'RSS_14',
                        'RSS_EXPANDED',
                        'UPC_A',
                        'UPC_E',
                        'UPC_EAN_EXTENSION',
                        'WX_CODE',
                        'CODE_25'
                      ]
                    },
                    {
                      name: 'charSet',
                      type: 'string'
                    },
                    {
                      name: 'path',
                      type: 'string'
                    },
                    {
                      name: 'rawData',
                      type: 'string'
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  setStorageSync: {
    '1.0.0': {
      params: [
        {
          name: 'key',
          type: 'string'
        },
        {
          name: 'data',
          type: 'any'
        }
      ]
    }
  },
  setStorage: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'key',
              type: 'string',
              required: true
            },
            {
              name: 'data',
              type: 'any',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  removeStorageSync: {
    '1.0.0': {
      params: [
        {
          name: 'key',
          type: 'string'
        }
      ]
    }
  },
  removeStorage: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'key',
              type: 'string',
              required: true
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  getStorageSync: {
    '1.0.0': {
      params: [
        {
          name: 'key',
          type: 'string'
        }
      ]
    }
  },
  getStorageInfoSync: {
    '1.0.0': {
      params: []
    }
  },
  getStorageInfo: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'keys',
                      type: 'array',
                      schema: [
                        {
                          type: 'string'
                        }
                      ]
                    },
                    {
                      name: 'currentSize',
                      type: 'number'
                    },
                    {
                      name: 'limitSize',
                      type: 'number'
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  getStorage: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'key',
              type: 'string',
              required: true
            },
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'data',
                      type: 'any'
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  clearStorageSync: {
    '1.0.0': {
      params: []
    }
  },
  clearStorage: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  stopLocationUpdate: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  startLocationUpdateBackground: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  startLocationUpdate: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  openLocation: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'latitude',
              type: 'number',
              required: true
            },
            {
              name: 'longitude',
              type: 'number',
              required: true
            },
            {
              name: 'scale',
              type: 'number',
              default: 18
            },
            {
              name: 'name',
              type: 'string'
            },
            {
              name: 'address',
              type: 'string'
            },
            {
              name: 'success',
              type: 'function'
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  onLocationChange: {
    '1.0.0': {
      params: [
        {
          type: 'function',
          returnProperty: [
            {
              type: 'object',
              schema: [
                {
                  name: 'latitude',
                  type: 'number'
                },
                {
                  name: 'longitude',
                  type: 'number'
                },
                {
                  name: 'speed',
                  type: 'number'
                },
                {
                  name: 'accuracy',
                  type: 'number'
                },
                {
                  name: 'altitude',
                  type: 'number'
                },
                {
                  name: 'verticalAccuracy',
                  type: 'number'
                },
                {
                  name: 'horizontalAccuracy',
                  type: 'number'
                }
              ]
            }
          ]
        }
      ]
    }
  },
  offLocationChange: {
    '1.0.0': {
      params: [
        {
          type: 'function'
        }
      ]
    }
  },
  openLocation: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'type',
              type: 'string',
              default: 'wgs84'
            },
            {
              name: 'altitude',
              type: 'string',
              default: 'false'
            },
            {
              name: 'isHighAccuracy',
              type: 'boolean',
              default: true
            },
            {
              name: 'highAccuracyExpireTime',
              type: 'number'
            },
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'latitude',
                      type: 'number'
                    },
                    {
                      name: 'longitude',
                      type: 'number'
                    },
                    {
                      name: 'speed',
                      type: 'number'
                    },
                    {
                      name: 'accuracy',
                      type: 'number'
                    },
                    {
                      name: 'altitude',
                      type: 'number'
                    },
                    {
                      name: 'verticalAccuracy',
                      type: 'number'
                    },
                    {
                      name: 'horizontalAccuracy',
                      type: 'number'
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
  chooseLocation: {
    '1.0.0': {
      params: [
        {
          type: 'object',
          schema: [
            {
              name: 'latitude',
              type: 'number'
            },
            {
              name: 'longitude',
              type: 'number'
            },
            {
              name: 'success',
              type: 'function',
              returnProperty: [
                {
                  type: 'object',
                  schema: [
                    {
                      name: 'name',
                      type: 'string'
                    },
                    {
                      name: 'address',
                      type: 'string'
                    },
                    {
                      name: 'latitude',
                      type: 'string'
                    },
                    {
                      name: 'longitude',
                      type: 'string'
                    }
                  ]
                }
              ]
            },
            {
              name: 'fail',
              type: 'function'
            },
            {
              name: 'complete',
              type: 'function'
            }
          ]
        }
      ]
    }
  },
}

const checkParam = (value, rule, parentValue, parentRule) => {
  if (!value && !rule.required) {
    return true
  }
  if (Array.isArray(rule.type)) {
    return rule.type.reduce((total, subType) => checkParam(value, subType) || total, false)
  } else {
    let customResult = true
    if (rule.customFunc && typeof rule.customFunc === 'function') {
      customResult = !!rule.customFunc(value)
    }
    let typeResult = true
    if (rule.type === 'any') {
      typeResult = true
    }
    if (rule.type === 'arrayBuffer') {
      typeResult = value instanceof ArrayBuffer
    }
    if (rule.type === 'array') {
      typeResult = Array.isArray(value) && value.reduce((total, item) => checkParam(item, rule.schema[0]) && total, true)
    }
    if (rule.type === 'string') {
      typeResult = typeof value === 'string'
    }
    if (rule.type === 'number') {
      typeResult = typeof value === 'number'
    }
    if (rule.type === 'boolean') {
      typeResult = typeof value === 'boolean'
    }
    if (rule.type === 'enum') {
      typeResult = checkParam(value, rule.schema[0]) && rule.validValues.indexOf(value) >= 0
    }
    if (rule.type === 'object') {
      typeResult = rule.schema ? rule.schema.reduce((total, propertyRule) => {
        const required = propertyRule.required, A = !!required
        const hasOwnProperty = (value && value.hasOwnProperty(propertyRule.name)), B = !!hasOwnProperty
        const valid = (value && checkParam(value[propertyRule.name], propertyRule, value, rule)), C = !!valid
        return total && ((!A && !B && !C) || (!A && !B && C) || (!A && B && C) || (A && B && C))
      }, true) : true
    }
    if (rule.type === 'function') {
      typeResult = value instanceof Function
    }
    return typeResult && customResult
    console.error('none type')
  }
}

const checkApiParams = (apiName, params) => {
  if (APIs && APIs[apiName]) {
    const rule = getApiRule(apiName, '1.0.0')
    const result = rule.reduce((total, item, index) => checkParam(params[index], item) && total, true)
    !result && (console.error(`${apiName} param is invalid`))
    return result
  } else {
    console.error(`${apiName} param config is not set`)
    return false
  }
}

const getApiRule = (apiName, version) => {
  return APIs[apiName][version].params || []
}

const checkApiCallbackParams = (apiName, callbackName, params) => {
  if (APIs && APIs[apiName]) {
    if (getApiRule(apiName, '1.0.0')) {
      const callback = getApiRule(apiName, '1.0.0')[0].schema.find(item => item.name === callbackName)
      if (callback) {
        const rule = callback.returnProperty
        if (rule) {
          const result = rule.map((item, index) => checkParam(params[index], item))
          !result[0] && (console.error(`${apiName}'s callback ${callbackName} param is invalid`))
          return result[0]
        } else {
          return true
        }
      } else {
        console.error(`${apiName} do not have ${callbackName}`)
        return false
      }
    } else {
      console.error(`${apiName} do not have ${callbackName}`)
      return false
    }
  } else {
    console.error(`${apiName} param config is not set`)
    return false
  }
}

const getDefault = (rule) => {
  if (rule.type === 'object') {
    const result = {}
    rule.schema && rule.schema.forEach((subRule) => {
      const subDefault = getDefault(subRule)
      if (subDefault !== undefined) {
        result[subRule.name] = subDefault
      }
    })
    return result
  }
  return rule.default
}

const getApiDefault = (apiName) => {
  if (APIs && APIs[apiName]) {
    const rule = getApiRule(apiName, '1.0.0')
    return rule.map((item) => getDefault(item))
  } else {
    console.error(`${apiName} param config is not set`)
    return undefined
  }
}

const extend = function (target, obj) {//obj合并到target对象
  if (!target) {
    return obj
  }
  for (let n in obj) {
    target[n] = obj[n]
  }
  return target
}

// 获取生成全局唯一id的函数
const getGetIdFunctionNew = () => {
  let index = 0
  return () => {
    index++
    return `${new Date().getTime()}-${index}`
  }
}
// id获取器
const getIdFunction = getGetIdFunctionNew()

// 所有回调
/*
  暂时设计为{
    apiName: {
      id:
    }
  }
  传给原生的id为  `${apiName}:${id}`
  */
const callbacks = {}
const defaultEventHandlers = {}
const handlers = {}

const u = navigator.userAgent
const isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1

// 兼容之前的写法
const Native = function (message) {
  // const u = navigator.userAgent;
  // const isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
  if (isAndroid) {
    window.MPJSCore.invokeHandler(JSON.stringify(message))
  } else {
    window.webkit.messageHandlers.native.postMessage(message)
  }
}

const invokePostMessage = function (message) {
  // const u = navigator.userAgent;
  // const isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
  if (isAndroid) {
    window.MPJSCore.invokeHandler(JSON.stringify(message))
  } else {
    window.webkit.messageHandlers.native.postMessage(message)
  }
}
const publishPostMessage = function (message) {
  if (isAndroid) {
    window.MPJSCore.invokeHandler(JSON.stringify(message))
  } else {
    window.webkit.messageHandlers.native.postMessage(message)
  }
}
const invoke = function (event, params, callback, customId) {
  const validParams = params || {}
  const id = customId || getIdFunction()
  // reportLog(event,params,'','invoke');
  !callbacks[event] && (callbacks[event] = {})
  callbacks[event][id] = callback
  // postMessage(event, paramsString, callbackId)
  serviceBridge.invokePostMessage({
    api: event,
    ...validParams,
    callbackId: `${event}:${id}`
  })
}
const invokeMethod = function (apiName, apiParams, extraFns, id) {
  const options = apiParams || {}
  const innerFns = extraFns || {}
  const params = {}
  for (let i in options) {
    'function' === typeof options[i] && (params[i] = options[i], delete options[i])
    // 'function' == typeof options[i] && (params[i] = Reporter.surroundThirdByTryCatch(options[i], 'at api ' + apiName + ' ' + i + ' callback function'), delete options[i]);
  }
  const sysEventFns = {};
  for (let s in innerFns) {
    'function' == typeof innerFns[s] && (sysEventFns[s] = innerFns[s])
    // 'function' == typeof innerFns[s] && (sysEventFns[s] = utils.surroundByTryCatchFactory(innerFns[s], 'at api ' + apiName + ' ' + s + ' callback function'));
  }
  serviceBridge.invoke(apiName, options, function (resp) {
    const res = resp || {}
    res.errMsg = (resp && resp.errMsg) || apiName + ':ok'
    const isOk = 0 === res.errMsg.indexOf(apiName + ':ok')
    const isCancel = 0 === res.errMsg.indexOf(apiName + ':cancel')
    const isFail = 0 === res.errMsg.indexOf(apiName + ':fail')
    if ('function' === typeof sysEventFns.beforeAll && sysEventFns.beforeAll(res), isOk) {
      'function' === typeof sysEventFns.beforeSuccess && sysEventFns.beforeSuccess(res)
      !checkApiCallbackParams(apiName, 'success', res) && console.warn(`params of ${apiName}'s callback success is invalid`)
      'function' === typeof params.success && params.success(res)
      'function' === typeof sysEventFns.afterSuccess && sysEventFns.afterSuccess(res)
    } else if (isCancel) {
      res.errMsg = res.errMsg.replace(apiName + ':cancel', apiName + ':fail cancel')
      !checkApiCallbackParams(apiName, 'fail', res) && console.warn(`params of ${apiName}'s callback fail is invalid`)
      'function' === typeof params.fail && params.fail(res)
      'function' === typeof sysEventFns.beforeCancel && sysEventFns.beforeCancel(res)
      !checkApiCallbackParams(apiName, 'cancel', res) && console.warn(`params of ${apiName}'s callback cancel is invalid`)
      'function' === typeof params.cancel && params.cancel(res)
      'function' === typeof sysEventFns.afterCancel && sysEventFns.afterCancel(res)
    } else if (isFail) {
      'function' === typeof sysEventFns.beforeFail && sysEventFns.beforeFail(res)
      !checkApiCallbackParams(apiName, 'fail', res) && console.warn(`params of ${apiName}'s callback fail is invalid`)
      'function' === typeof params.fail && params.fail(res)
      'function' === typeof sysEventFns.afterFail && params.afterFail(res)
      // var rt = !0
      // 'function' == typeof sysEventFns.afterFail && (rt = sysEventFns.afterFail(res))
      // rt !== !1 && Reporter.reportIDKey({
      //   key: apiName + '_fail'
      // })
    }
    !checkApiCallbackParams(apiName, 'complete', res) && console.warn(`params of ${apiName}'s callback complete is invalid`)
    'function' === typeof params.complete && params.complete(res)
    'function' === typeof sysEventFns.afterAll && sysEventFns.afterAll(res)
  }, id)
  // Reporter.reportIDKey({
  //   key: apiName
  // })
}
const invokeMethodSync = function (apiName, apiParams, extraFns) {
  const options = apiParams || {}
  const innerFns = extraFns || {}
  const params = {}
  for (let i in options) {
    'function' === typeof options[i] && (params[i] = options[i], delete options[i])
    // 'function' == typeof options[i] && (params[i] = Reporter.surroundThirdByTryCatch(options[i], 'at api ' + apiName + ' ' + i + ' callback function'), delete options[i]);
  }
  const sysEventFns = {};
  for (let s in innerFns) {
    // 'function' == typeof innerFns[s] && (sysEventFns[s] = utils.surroundByTryCatchFactory(innerFns[s], 'at api ' + apiName + ' ' + s + ' callback function'));
  }
  let lock = true
  let rt
  serviceBridge.invoke(apiName, options, function (resp) {
    const res = resp || {}
    res.errMsg = (resp && resp.errMsg) || apiName + ':ok'
    const isOk = 0 === res.errMsg.indexOf(apiName + ':ok')
    const isCancel = 0 === res.errMsg.indexOf(apiName + ':cancel')
    const isFail = 0 === res.errMsg.indexOf(apiName + ':fail')
    if ('function' === typeof sysEventFns.beforeAll && sysEventFns.beforeAll(res), isOk) {
      'function' === typeof sysEventFns.beforeSuccess && sysEventFns.beforeSuccess(res)
      rt = res
      delete res.errMsg
      'function' === typeof sysEventFns.afterSuccess && sysEventFns.afterSuccess(res)
    } else if (isCancel) {
      res.errMsg = res.errMsg.replace(apiName + ':cancel', apiName + ':fail cancel')
      'function' === typeof sysEventFns.beforeCancel && sysEventFns.beforeCancel(res)
      rt = res
      delete res.errMsg
      'function' === typeof sysEventFns.afterCancel && sysEventFns.afterCancel(res)
    } else if (isFail) {
      'function' === typeof sysEventFns.beforeFail && sysEventFns.beforeFail(res)
      rt = res
      delete res.errMsg
      'function' === typeof sysEventFns.afterFail && sysEventFns.afterFail(res)
      // var rt = !0
      // 'function' == typeof sysEventFns.afterFail && (rt = sysEventFns.afterFail(res))
      // rt !== !1 && Reporter.reportIDKey({
      //   key: apiName + '_fail'
      // })
    }
    'function' === typeof sysEventFns.afterAll && sysEventFns.afterAll(res)
    lock = false
  })
  return new Promise((resolve, reject) => {
    const int = setInterval(() => {
      if (!lock) {
        clearInterval(int)
        resolve(rt)
      }
    }, 1000)
  })
  // Reporter.reportIDKey({
  //   key: apiName
  // })
}
const invokeCallbackHandler = function (callbackId, params) {
  const callbackIdPattern = /^(\w{1,}):(\d{1,}-\d{1,})$/
  if (callbackIdPattern.test(callbackId)) {
    const apiName = RegExp.$1
    const timestrapId = RegExp.$2
    const callback = callbacks[apiName][timestrapId]
    // reportLog('invokeCallbackHandler:'+callbackId,params,'','api2app2service_get');
    typeof callback === 'function' && callback(params),
      delete callbacks[apiName][timestrapId]
    // isIOS && retrieveIframe(callbackId)
  } else {
    console.error('callbackId has not existed')
  }
}
const publishHandler = function (event, paramsString, webviewIds) {
  serviceBridge.publishPostMessage({
    api: event,
    ...paramsString,
    webviewIds: webviewIds
  })
}
// const on = function (eventName, handler) {
//   defaultEventHandlers[eventName] = handler
// }
const publish = function (eventName, params, webviewIds) {
  // publishHandler
  const lWebviewIds = webviewIds || []
  // const event = eventPrefix + eventName
  const event = eventName

  // const paramsString = JSON.stringify(params)
  const paramsString = params || {}
  const webviewIdsJSON = JSON.stringify(lWebviewIds)
  publishHandler(event, paramsString, webviewIdsJSON)
}
const subscribe = function (eventName, handler) {
  if (!handlers.hasOwnProperty(eventName)) {
    handlers[eventName] = {}
  }
  const id = getIdFunction()
  handlers[eventName][id] = handler
  return id
}
const unsubscribe = function (eventName, id) {
  if (hadnlers[eventName] && hadnlers[eventName][id]) {
    delete hadnlers[eventName][id]
  }
}
const subscribeHandler = function (eventName, data, webviewId, reportParams) {
  // 执行注册的回调
  // const handler = defaultEventHandlers[eventName] || handlers[eventName]
  // reportLog('subscribeHandler:'+eventName,data,[webviewId||''],'app2view_get');
  const allHandler = handlers[eventName]
  Object.values(allHandler).forEach((handler) => {
    handler && typeof handler === 'function' && handler(data, webviewId, reportParams)
  })
}

const serviceBridge = {
  invokePostMessage,
  invoke,
  invokeMethod,
  invokeMethodSync,
  invokeCallbackHandler,
  publishPostMessage,
  publishHandler,
  // on,
  publish,
  unsubscribe,
  subscribe,
  subscribeHandler
}

const eventPrefix = 'systemEvent'

const Bridge = {
  // 关闭小程序
  closeProgram: function () {
    const extendDefault = getApiDefault('closeProgram').map((item, index) => extend(item, arguments[index]))
    checkApiParams('closeProgram', extendDefault) && serviceBridge.invokeMethod('closeProgram', extendDefault[0])
  },
  // 路由
  switchTab: function () {
    const extendDefault = getApiDefault('switchTab').map((item, index) => extend(item, arguments[index]))
    const objCopy = extend({}, extendDefault)
    if (/\?.*$/.test(objCopy.url)) {
      console.warn('Bridge.switchTab: url 不支持 queryString')
      objCopy.url = objCopy.url.replace(/\?.*$/, '')
    }
    checkApiParams('switchTab', extendDefault) && serviceBridge.invokeMethod('switchTab', extendDefault[0])
  },
  redirectTo: function () {
    const extendDefault = getApiDefault('redirectTo').map((item, index) => extend(item, arguments[index]))
    checkApiParams('redirectTo', extendDefault) && serviceBridge.invokeMethod('redirectTo', extendDefault[0])
  },
  navigateTo: function () {
    const extendDefault = getApiDefault('navigateTo').map((item, index) => extend(item, arguments[index]))
    checkApiParams('navigateTo', extendDefault) && serviceBridge.invokeMethod('navigateTo', extendDefault[0])
  },
  navigateBack: function () {
    const extendDefault = getApiDefault('navigateBack').map((item, index) => extend(item, arguments[index]))
    checkApiParams('navigateBack', extendDefault) && serviceBridge.invokeMethod('navigateBack', extendDefault[0])
  },
  reLaunch: function () {
    const extendDefault = getApiDefault('reLaunch').map((item, index) => extend(item, arguments[index]))
    checkApiParams('reLaunch', extendDefault) && serviceBridge.invokeMethod('reLaunch', extendDefault[0])
  },
  showNavigationBarLoading: function (obj = {}) {
    var message = {
      api: "showNavigationBarLoading",
    }
    Native(message)
  },
  setNavigationBarTitle: function (obj = {}) {
    var message = {
      api: "setNavigationBarTitle",
      title: obj.title,
    }
    Native(message)
  },
  setNavigationBarColor: function () {
    const extendDefault = getApiDefault('setNavigationBarColor').map((item, index) => extend(item, arguments[index]))
    checkApiParams('setNavigationBarColor', extendDefault) && serviceBridge.invokeMethod('setNavigationBarColor', extendDefault[0])
  },
  hideNavigationBarLoading: function () {
    const extendDefault = getApiDefault('hideNavigationBarLoading').map((item, index) => extend(item, arguments[index]))
    checkApiParams('hideNavigationBarLoading', extendDefault) && serviceBridge.invokeMethod('hideNavigationBarLoading', extendDefault[0])
  },
  hideHomeButton: function () {
    const extendDefault = getApiDefault('hideHomeButton').map((item, index) => extend(item, arguments[index]))
    checkApiParams('hideHomeButton', extendDefault) && serviceBridge.invokeMethod('hideHomeButton', extendDefault[0])
  },
  // 界面
  showToast: function (obj = {}) {
    var message = {
      api: "showToast",
      title: obj.title,
      icon: obj.icon || 'success',
      image: obj.image,
      duration: obj.duration || 1500,
      mask: obj.mask || false
    }
    Native(message)
  },
  hideToast: function (obj = {}) {
    var message = {
      api: "hideToast"
    }
    Native(message)
  },
  showModal: function (obj = {}) {
    var message = {
      api: "showModal",
      title: obj.title,
      content: obj.content,
      showCancel: obj.showCancel,
      cancelText: obj.cancelText,
      cancelColor: obj.cancelColor,
      confirmText: obj.confirmText,
      confirmColor: obj.confirmColor
    }
    Native(message)
  },
  showActionSheet: function () {
    const extendDefault = getApiDefault('showActionSheet').map((item, index) => extend(item, arguments[index]))
    checkApiParams('showActionSheet', extendDefault) && serviceBridge.invokeMethod('showActionSheet', extendDefault[0])
  },
  showLoading: function (obj = {}) {
    var message = {
      api: "showLoading",
      title: obj.title,
      mask: obj.mask
    }
    Native(message)
  },
  hideLoading: function () {
    var message = {
      api: "hideLoading"
    }
    Native(message)
  },
  setBackgroundColor: function () {
    const extendDefault = getApiDefault('setBackgroundColor').map((item, index) => extend(item, arguments[index]))
    checkApiParams('setBackgroundColor', extendDefault) && serviceBridge.invokeMethod('setBackgroundColor', extendDefault[0])
  },
  setBackgroundTextStyle: function () {
    const extendDefault = getApiDefault('setBackgroundTextStyle').map((item, index) => extend(item, arguments[index]))
    checkApiParams('setBackgroundTextStyle', extendDefault) && serviceBridge.invokeMethod('setBackgroundTextStyle', extendDefault[0])
  },
  showTabBarRedDot: function () {
    const extendDefault = getApiDefault('showTabBarRedDot').map((item, index) => extend(item, arguments[index]))
    checkApiParams('showTabBarRedDot', extendDefault) && serviceBridge.invokeMethod('showTabBarRedDot', extendDefault[0])
  },
  showTabBar: function () {
    const extendDefault = getApiDefault('showTabBar').map((item, index) => extend(item, arguments[index]))
    checkApiParams('showTabBar', extendDefault) && serviceBridge.invokeMethod('showTabBar', extendDefault[0])
  },
  setTabBarStyle: function () {
    const extendDefault = getApiDefault('setTabBarStyle').map((item, index) => extend(item, arguments[index]))
    checkApiParams('setTabBarStyle', extendDefault) && serviceBridge.invokeMethod('setTabBarStyle', extendDefault[0])
  },
  setTabBarItem: function () {
    const extendDefault = getApiDefault('setTabBarItem').map((item, index) => extend(item, arguments[index]))
    checkApiParams('setTabBarItem', extendDefault) && serviceBridge.invokeMethod('setTabBarItem', extendDefault[0])
  },
  setTabBarBadge: function () {
    const extendDefault = getApiDefault('setTabBarBadge').map((item, index) => extend(item, arguments[index]))
    checkApiParams('setTabBarBadge', extendDefault) && serviceBridge.invokeMethod('setTabBarBadge', extendDefault[0])
  },
  removeTabBarBadge: function () {
    const extendDefault = getApiDefault('removeTabBarBadge').map((item, index) => extend(item, arguments[index]))
    checkApiParams('removeTabBarBadge', extendDefault) && serviceBridge.invokeMethod('removeTabBarBadge', extendDefault[0])
  },
  hideTabBarRedDot: function () {
    const extendDefault = getApiDefault('hideTabBarRedDot').map((item, index) => extend(item, arguments[index]))
    checkApiParams('hideTabBarRedDot', extendDefault) && serviceBridge.invokeMethod('hideTabBarRedDot', extendDefault[0])
  },
  hideTabBar: function () {
    const extendDefault = getApiDefault('hideTabBar').map((item, index) => extend(item, arguments[index]))
    checkApiParams('hideTabBar', extendDefault) && serviceBridge.invokeMethod('hideTabBar', extendDefault[0])
  },
  stopPullDownRefresh: function () {
    const extendDefault = getApiDefault('stopPullDownRefresh').map((item, index) => extend(item, arguments[index]))
    checkApiParams('stopPullDownRefresh', extendDefault) && serviceBridge.invokeMethod('stopPullDownRefresh', extendDefault[0])
  },
  startPullDownRefresh: function () {
    const extendDefault = getApiDefault('startPullDownRefresh').map((item, index) => extend(item, arguments[index]))
    checkApiParams('startPullDownRefresh', extendDefault) && serviceBridge.invokeMethod('startPullDownRefresh', extendDefault[0])
  },
  pageScrollTo() {
    const extendDefault = getApiDefault('pageScrollTo').map((item, index) => extend(item, arguments[index]))
    if (checkApiParams('pageScrollTo', extendDefault)) {
      const selector = extendDefault[0].selector
      const scrollTop = extendDefault[0].scrollTop
      const success = extendDefault[0].success
      const fail = extendDefault[0].fail
      const complete = extendDefault[0].complete
      if (selector) {
        const elm = document.querySelector(selector)
        if (elm) {
          elm.scrollIntoView(true)
          success && 'function' === typeof success && success()
        } else {
          fail && 'function' === typeof fail && fail()
        }
      } else if (scrollTop === 0 || scrollTop) {
        window.scrollTo(0, scrollTop)
        success && 'function' === typeof success && success()
      }
      complete && 'function' === typeof complete && complete()
    }
  },
  nextTick: function () {
    const extendDefault = getApiDefault('nextTick').map((item, index) => extend(item, arguments[index]))
    if (checkApiParams('nextTick', extendDefault)) {
      Vue.nextTick(extendDefault[0])
    }
  },
  onKeyboardHeightChange: function () {
    const extendDefault = getApiDefault('onKeyboardHeightChange').map((item, index) => extend(item, arguments[index]))
    checkApiParams('onKeyboardHeightChange', extendDefault) && serviceBridge.subscribe('MP-onKeyboardHeightChange', extendDefault[0])
  },
  hideKeyboard: function () {
    const extendDefault = getApiDefault('hideKeyboard').map((item, index) => extend(item, arguments[index]))
    checkApiParams('hideKeyboard', extendDefault) && serviceBridge.invokeMethod('hideKeyboard', extendDefault[0])
  },
  getSelectedTextRange: function () {
    const extendDefault = getApiDefault('getSelectedTextRange').map((item, index) => extend(item, arguments[index]))
    checkApiParams('getSelectedTextRange', extendDefault) && serviceBridge.invokeMethod('getSelectedTextRange', extendDefault[0])
  },
  // 网络
  request: function () {
    const extendDefault = getApiDefault('request').map((item, index) => extend(item, arguments[index]))
    const id = getIdFunction()
    if (checkApiParams('request', extendDefault)) {
      if (typeof extendDefault[0].data !== 'string') {
        if (extendDefault[0].method === 'GET') {
          extendDefault[0].url = addQueryStringToUrl(extendDefault[0].url, extendDefault[0].data)
          extendDefault[0].data = ''
        }
        if (extendDefault[0].method === 'POST' && extendDefault[0].header && extendDefault[0].header['content-type'] === 'application/json') {
          extendDefault[0].data = JSON.stringify(extendDefault[0].data)
        }
        if (extendDefault[0].method === 'POST' && extendDefault[0].header && extendDefault[0].header['content-type'] === 'application/x-www-form-urlencoded') {
          extendDefault[0].data = urlEncodeFormData(extendDefault[0].data)
        }
      }
      serviceBridge.invokeMethod('request', extendDefault[0], {
        beforeSuccess: function (res) {
          if (extendDefault[0].dataType === 'json') {
            try {
              res.data = JSON.parse(res.data)
            } catch (e) {
            }
          }
          res.statusCode = parseInt(res.statusCode)
        }
      }, id)
      return new RequestTask(id)
    } else {
      return null
    }
  },
  // response: async function (obj = {}) {
  //   // 微信小程序正确返回格式
  //   // {
  //   //     "data": {
  //   //         "state": 1,
  //   //         "data": [
  //   //         {
  //   //             "appid": "1vksqwrniqpnj53txbaudozf8lhb9geh",
  //   //             "version": "0.0.7"
  //   //         }
  //   //         ],
  //   //         "msg": "success",
  //   //         "ret": 1
  //   //     },
  //   //     "header": {
  //   //         "Server": "nginx/1.15.6",
  //   //         "Date": "Thu, 14 Nov 2019 03:27:41 GMT",
  //   //         "Content-Type": "text/json;charset=UTF-8",
  //   //         "Transfer-Encoding": "chunked",
  //   //         "Connection": "keep-alive",
  //   //         "Access-Control-Allow-Origin": "",
  //   //         "Strict-Transport-Security": "max-age=15724800; includeSubDomains"
  //   //     },
  //   //     "statusCode": 200,
  //   //     "cookies": [],
  //   //     "errMsg": "request:ok"
  //   // }
  //   // 错误返回
  //   // {
  //   //   "errMsg":"request:fail invalid url \"2242\""
  //   // }
  //   const callbackMap = requestCallbacks.getCallbackMap(obj.id)
  //   if (callbackMap) {
  //     if (obj.response.statusCode) {
  //       await callbackMap.success(obj.response)
  //     } else {
  //       await callbackMap.fail(obj.response)
  //     }
  //     await callbackMap.complete(obj.response)
  //     requestCallbacks.removeCallbackMap(obj.id)
  //   }
  // },
  // websocket相关的success等回调函数 代表的是接口调用结果回调，不代表实际结果回调
  sendSocketMessage: function () {
    const extendDefault = getApiDefault('sendSocketMessage').map((item, index) => extend(item, arguments[index]))
    if (checkApiParams('sendSocketMessage', extendDefault)) {
      let socketTask = socketTaskManager.getFirst()
      if (socketTask) {
        socketTask.send(extendDefault[0])
      } else {
        console.error('none websocket is connecting')
      }
    }
  },
  onSocketOpen: function () {
    const extendDefault = getApiDefault('onSocketOpen').map((item, index) => arguments[index] || item)
    if (checkApiParams('onSocketOpen', extendDefault)) {
      let socketTask = socketTaskManager.getFirst()
      if (socketTask) {
        socketTask.onOpen(extendDefault[0])
      } else {
        console.error('none websocket is connecting')
      }
    }
  },
  onSocketMessage: function () {
    const extendDefault = getApiDefault('onSocketMessage').map((item, index) => arguments[index] || item)
    if (checkApiParams('onSocketMessage', extendDefault)) {
      let socketTask = socketTaskManager.getFirst()
      if (socketTask) {
        socketTask.onMessage(extendDefault[0])
      } else {
        console.error('none websocket is connecting')
      }
    }
  },
  onSocketError: function () {
    const extendDefault = getApiDefault('onSocketError').map((item, index) => arguments[index] || item)
    if (checkApiParams('onSocketError', extendDefault)) {
      let socketTask = socketTaskManager.getFirst()
      if (socketTask) {
        socketTask.onError(extendDefault[0])
      } else {
        console.error('none websocket is connecting')
      }
    }
  },
  onSocketClose: function () {
    const extendDefault = getApiDefault('onSocketClose').map((item, index) => arguments[index] || item)
    if (checkApiParams('onSocketClose', extendDefault)) {
      let socketTask = socketTaskManager.getFirst()
      if (socketTask) {
        socketTask.onClose(extendDefault[0])
      } else {
        console.error('none websocket is connecting')
      }
    }
  },
  connectSocket: function () {
    const extendDefault = getApiDefault('connectSocket').map((item, index) => extend(item, arguments[index]))
    const id = getIdFunction()
    if (checkApiParams('connectSocket', extendDefault)) {
      let socketTask = null
      let obj = extendDefault[0]
      if (obj.url) {
        const id = getIdFunction()
        try {
          socketTask = new SocketTask(id, obj.url, obj.protocols)
          socketTask.onOpen(() => { })
          socketTask.onMessage(() => { })
          socketTask.onError(() => { })
          socketTask.onClose(() => { })
          socketTaskManager.add(socketTask)
          // const checkSocket = () => {
          //     const instance = socketCallbacks.getCallbackMap(id)
          //     if (instance) {
          //         const readyState = instance.socketInstance.readyState
          //         if (readyState !== WebSocket.CONNECTING) {
          //             if (readyState === WebSocket.OPEN) {
          //                 success()
          //             } else if (readyState === WebSocket.CLOSED) {
          //                 fail()
          //             }
          //             complete()
          //             interval && clearInterval(interval)
          //         }
          //     }
          // }
          // checkSocket()
          // let interval = setInterval(checkSocket, 500);
          obj.success && obj.success()
          obj.complete && obj.complete()
          return socketTask
        } catch (error) {
          obj.fail && obj.fail()
          obj.complete && obj.complete()
          return socketTask
        }
      } else {
        obj.fail && obj.fail()
        obj.complete && obj.complete()
        return socketTask
      }
    } else {
      return null
    }
  },
  closeSocket: function () {
    const extendDefault = getApiDefault('closeSocket').map((item, index) => arguments[index] || item)
    if (checkApiParams('closeSocket', extendDefault)) {
      let socketTask = socketTaskManager.getFirst()
      if (socketTask) {
        socketTask.close(extendDefault[0])
      } else {
        console.error('none websocket is connecting')
      }
    }
  },
  downloadFile: function (obj = {}) {
    var message = {
      api: "downloadFile",
      url: obj.url,
      header: obj.header,
      filePath: obj.filePath
    }
    Native(message)
  },
  uploadFile: function (obj = {}) {
    var message = {
      api: "uploadFile",
      url: obj.url,
      filePath: obj.filePath,
      name: obj.name,
      header: obj.header,
      formData: obj.formData
    }
    Native(message)
  },
  // 媒体
  // 图片
  saveImageToPhotosAlbum: function (obj = {}) {
    var message = {
      api: "saveImageToPhotosAlbum",
      filePath: obj.filePath
    }
  },
  // 设备
  // 扫码
  scanCode: function (obj = {}) {
    var message = {
      api: "scanCode",
      onlyFromCamera: obj.onlyFromCamera,
      scanType: obj.scanType
    }
    Native(message)
  },
  // 助记词
  createMnemonic: function () {
    var message = {
      api: "createMnemonic",
    }
    Native(message)
  },
  createSeed: function (obj = {}) {
    var message = {
      api: "createSeed",
      mnemonic: obj.mnemonic
    }
    Native(message)
  },
  // 数据缓存
  setStorageSync: async function () {
    const extendDefault = getApiDefault('setStorageSync').map((item, index) => {
      return typeof item === 'object' ? extend(item, arguments[index]) : (arguments[index] === undefined ? item : arguments[index])
    })
    if (checkApiParams('setStorageSync', extendDefault)) {
      // setTimeout(() => {
      //   serviceBridge.invokeCallbackHandler(idddddd, {
      //     value: '54353543543'
      //   })
      // }, 1000)
      const obj = {}
      getApiRule('setStorageSync', '1.0.0').map((item, index) => {
        obj[item.name] = extendDefault[index]
      })
      return (await serviceBridge.invokeMethodSync('setStorageSync', obj))
    }
  },
  setStorage: function () {
    const extendDefault = getApiDefault('setStorage').map((item, index) => extend(item, arguments[index]))
    checkApiParams('setStorage', extendDefault) && serviceBridge.invokeMethod('setStorage', extendDefault[0])
  },
  removeStorageSync: async function () {
    const extendDefault = getApiDefault('removeStorageSync').map((item, index) => {
      // 参数可能为0或false，需要特殊处理，未完成
      return typeof item === 'object' ? extend(item, arguments[index]) : (arguments[index] || item)
    })
    if (checkApiParams('removeStorageSync', extendDefault)) {
      const obj = {}
      getApiRule('removeStorageSync', '1.0.0').map((item, index) => {
        obj[item.name] = extendDefault[index]
      })
      return (await serviceBridge.invokeMethodSync('removeStorageSync', obj))
    }
  },
  removeStorage: function () {
    const extendDefault = getApiDefault('removeStorage').map((item, index) => extend(item, arguments[index]))
    checkApiParams('removeStorage', extendDefault) && serviceBridge.invokeMethod('removeStorage', extendDefault[0])
  },
  getStorageSync: async function () {
    const extendDefault = getApiDefault('getStorageSync').map((item, index) => {
      // 参数可能为0或false，需要特殊处理，未完成
      return typeof item === 'object' ? extend(item, arguments[index]) : (arguments[index] || item)
    })
    if (checkApiParams('getStorageSync', extendDefault)) {
      const obj = {}
      getApiRule('getStorageSync', '1.0.0').map((item, index) => {
        obj[item.name] = extendDefault[index]
      })
      return (await serviceBridge.invokeMethodSync('getStorageSync', obj))
    }
  },
  getStorageInfoSync: async function () {
    const extendDefault = getApiDefault('getStorageInfoSync').map((item, index) => {
      // 参数可能为0或false，需要特殊处理，未完成
      return typeof item === 'object' ? extend(item, arguments[index]) : (arguments[index] || item)
    })
    if (checkApiParams('getStorageInfoSync', extendDefault)) {
      const obj = {}
      getApiRule('getStorageInfoSync', '1.0.0').map((item, index) => {
        obj[item.name] = extendDefault[index]
      })
      return (await serviceBridge.invokeMethodSync('getStorageInfoSync', obj))
    }
  },
  getStorageInfo: function () {
    const extendDefault = getApiDefault('getStorageInfo').map((item, index) => extend(item, arguments[index]))
    checkApiParams('getStorageInfo', extendDefault) && serviceBridge.invokeMethod('getStorageInfo', extendDefault[0])
  },
  getStorage: function () {
    const extendDefault = getApiDefault('getStorage').map((item, index) => extend(item, arguments[index]))
    checkApiParams('getStorage', extendDefault) && serviceBridge.invokeMethod('getStorage', extendDefault[0])
  },
  clearStorageSync: async function () {
    const extendDefault = getApiDefault('clearStorageSync').map((item, index) => {
      // 参数可能为0或false，需要特殊处理，未完成
      return typeof item === 'object' ? extend(item, arguments[index]) : (arguments[index] || item)
    })
    if (checkApiParams('clearStorageSync', extendDefault)) {
      const obj = {}
      getApiRule('clearStorageSync', '1.0.0').map((item, index) => {
        obj[item.name] = extendDefault[index]
      })
      return (await serviceBridge.invokeMethodSync('clearStorageSync', obj))
    }
  },
  clearStorage: function () {
    const extendDefault = getApiDefault('clearStorage').map((item, index) => extend(item, arguments[index]))
    checkApiParams('clearStorage', extendDefault) && serviceBridge.invokeMethod('clearStorage', extendDefault[0])
  },
  getSystemInfo: function () {
    const extendDefault = getApiDefault('getSystemInfo').map((item, index) => extend(item, arguments[index]))
    checkApiParams('getSystemInfo', extendDefault) && serviceBridge.invokeMethod('getSystemInfo', extendDefault[0])
  },
  async getSystemInfoSync() {
    const extendDefault = getApiDefault('getSystemInfoSync').map((item, index) => {
      // 参数可能为0或false，需要特殊处理，未完成
      return typeof item === 'object' ? extend(item, arguments[index]) : (arguments[index] || item)
    })
    if (checkApiParams('getSystemInfoSync', extendDefault)) {
      const obj = {}
      getApiRule('getSystemInfoSync', '1.0.0').map((item, index) => {
        obj[item.name] = extendDefault[index]
      })
      return (await serviceBridge.invokeMethodSync('getSystemInfoSync', obj))
    }
  },
  stopLocationUpdate() {
    const extendDefault = getApiDefault('stopLocationUpdate').map((item, index) => extend(item, arguments[index]))
    checkApiParams('stopLocationUpdate', extendDefault) && serviceBridge.invokeMethod('stopLocationUpdate', extendDefault[0])
  },
  startLocationUpdateBackground() {
    const extendDefault = getApiDefault('startLocationUpdateBackground').map((item, index) => extend(item, arguments[index]))
    checkApiParams('startLocationUpdateBackground', extendDefault) && serviceBridge.invokeMethod('startLocationUpdateBackground', extendDefault[0])
  },
  startLocationUpdate() {
    const extendDefault = getApiDefault('startLocationUpdate').map((item, index) => extend(item, arguments[index]))
    checkApiParams('startLocationUpdate', extendDefault) && serviceBridge.invokeMethod('startLocationUpdate', extendDefault[0])
  },
  openLocation() {
    const extendDefault = getApiDefault('openLocation').map((item, index) => extend(item, arguments[index]))
    checkApiParams('openLocation', extendDefault) && serviceBridge.invokeMethod('openLocation', extendDefault[0])
  },
  onLocationChange() {
    const extendDefault = getApiDefault('onLocationChange').map((item, index) => extend(item, arguments[index]))
    checkApiParams('onLocationChange', extendDefault) && serviceBridge.subscribe('MP-onLocationChange', extendDefault[0])
  },
  offLocationChange() {
    const extendDefault = getApiDefault('offLocationChange').map((item, index) => extend(item, arguments[index]))
    if (checkApiParams('offLocationChange', extendDefault)) {
      const targetHandlers = handlers['MP-onLocationChange']
      let resultId = null
      if (targetHandlers) {
        Object.keys(targetHandlers).forEach(id => {
          if (targetHandlers[id].toString() === extendDefault[0].toString()) {
            resultId = id
          }
        })
        if (resultId) {
          serviceBridge.unsubscribe('MP-onLocationChange', resultId)
        }
      }
    }
  },
  LifeCycle: {
    onReady(querystring) {
      let qsObj = {}
      if (querystring) {
        qsObj = parseQueryString(querystring)
      }
      window.pageIns && window.pageIns.onReady && (window.pageIns.onReady(qsObj))
    },
    onShow() {
      window.pageIns && window.pageIns.onShow && (window.pageIns.onShow())
    },
    onHide() {
      window.pageIns && window.pageIns.onHide && (window.pageIns.onHide())
    }
  },
  Component: {
    showInput: function (obj = {}) {
      // let message = {
      //   api: 'showInput',
      //   x: obj.x,
      //   y: obj.y,
      //   width: obj.width,
      //   height: obj.height,
      //   uid: obj.uid,
      //   success: obj.success
      // }
      // Native(message)
      serviceBridge.invokeMethod('showInput', obj)
    }
  }
}
