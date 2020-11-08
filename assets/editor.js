// 这些只是用来看的

/** 配置对象
 * @typeof window.config
 * @property {string} initialValue
 * @property {(text: string) => void} onChanged
 * @property {Function} onFocused
 * @property {Function} onBlurred
 */

/** 全局函数
* window.insertText = (text: string, offset = 0) => void
*/

function init() {
  const styleTag = document.createElement('style')
  document.head.appendChild(styleTag)
  styleTag.innerText = `
    html, body {
      height: 100%;
      margin: 0;
    }
  `
  
  const textarea = document.createElement('textarea')
  document.body.appendChild(textarea)
  textarea.style.cssText = `
    width: 100%;
    height: 100%;
    border: none;
    outline: none;
    box-sizing: border-box;
    padding: 5px;
    overflow-y: auto;
    font-size: 14px;
    resize: none;
    background-color: var(--bgColor);
    color: var(--textColor);
    caret-color: var(--caretColor);
    font-family: 'Consolas';
  `

  textarea.value = config.initialValue

  textarea.addEventListener('input', () => config.onChanged(textarea.value))

  textarea.addEventListener('focus', () => config.onFocused())
  textarea.addEventListener('blur', () => config.onBlurred())

  window.insertText = (text, offset = 0) => {
    const content = textarea.value
    const currentLocation = textarea.selectionStart
    const before = content.substring(0, currentLocation)
    const after = content.substring(currentLocation)

    textarea.value = before + text + after
    const location = currentLocation + text.length - offset
    textarea.selectionStart = textarea.selectionEnd = location
    textarea.focus()
    config.onChanged(textarea.value)
  }
}