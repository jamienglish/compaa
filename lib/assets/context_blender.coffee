# See - https://github.com/Phrogz/context-blender/blob/master/context_blender.js
if window.CanvasRenderingContext2D and CanvasRenderingContext2D::getImageData
  defaultOffsets =
    destX: 0
    destY: 0
    sourceX: 0
    sourceY: 0
    width: "auto"
    height: "auto"

  CanvasRenderingContext2D::blendOnto = (destContext, blendMode, offsetOptions) ->
    offsets = {}
    for key of defaultOffsets
      offsets[key] = (offsetOptions and offsetOptions[key]) or defaultOffsets[key]  if defaultOffsets.hasOwnProperty(key)
    offsets.width = @canvas.width  if offsets.width is "auto"
    offsets.height = @canvas.height  if offsets.height is "auto"
    offsets.width = Math.min(offsets.width, @canvas.width - offsets.sourceX, destContext.canvas.width - offsets.destX)
    offsets.height = Math.min(offsets.height, @canvas.height - offsets.sourceY, destContext.canvas.height - offsets.destY)
    srcD = @getImageData(offsets.sourceX, offsets.sourceY, offsets.width, offsets.height)
    dstD = destContext.getImageData(offsets.destX, offsets.destY, offsets.width, offsets.height)
    src = srcD.data
    dst = dstD.data
    sA = undefined
    dA = undefined
    len = dst.length
    sRA = undefined
    sGA = undefined
    sBA = undefined
    dRA = undefined
    dGA = undefined
    dBA = undefined
    dA2 = undefined
    demultiply = undefined
    px = 0

    while px < len
      sA = src[px + 3] / 255
      dA = dst[px + 3] / 255
      dA2 = (sA + dA - sA * dA)
      dst[px + 3] = dA2 * 255
      sRA = src[px] / 255 * sA
      dRA = dst[px] / 255 * dA
      sGA = src[px + 1] / 255 * sA
      dGA = dst[px + 1] / 255 * dA
      sBA = src[px + 2] / 255 * sA
      dBA = dst[px + 2] / 255 * dA
      demultiply = 255 / dA2
      dst[px] = (sRA + dRA - 2 * Math.min(sRA * dA, dRA * sA)) * demultiply
      dst[px + 1] = (sGA + dGA - 2 * Math.min(sGA * dA, dGA * sA)) * demultiply
      dst[px + 2] = (sBA + dBA - 2 * Math.min(sBA * dA, dBA * sA)) * demultiply
      px += 4
    destContext.putImageData dstD, offsets.destX, offsets.destY

  
  # For querying of functionality from other libraries
  modes = CanvasRenderingContext2D::blendOnto.supportedBlendModes = "normal src-over screen multiply difference src-in plus add overlay hardlight colordodge dodge colorburn burn darken lighten exclusion".split(" ")
  supports = CanvasRenderingContext2D::blendOnto.supports = {}
  i = 0
  len = modes.length

  while i < len
    supports[modes[i]] = true
    ++i
