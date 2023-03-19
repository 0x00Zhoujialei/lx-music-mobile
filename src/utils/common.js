import { hideLyric } from './lyricDesktop'
import { destroy as destroyPlayer } from '@/plugins/player/utils'
import { exitApp as utilExitApp } from './utils'
import {Platform} from "react-native";

let isDestroying = false
export const exitApp = () => {
  if (Platform.OS !== 'android') return
  if (isDestroying) return
  isDestroying = true
  Promise.all([
    hideLyric(),
    destroyPlayer(),
  ]).finally(() => {
    isDestroying = false
    utilExitApp()
  })
}
