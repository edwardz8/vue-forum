const ID_TOKEN_KEY = `OqFd0Fhcq63oqb9Vey7d4M00RUsSFBGqaOPiVX/BH6wYo7nSnru9qv3bb73Iii1y
YVZs8cC2GJkn6LLP`;

export const getToken = () => {
    return window.localStorage.getItem(ID_TOKEN_KEY)
}

export const saveToken = token => {
    window.localStorage.setItem(ID_TOKEN_KEY, token)
}

export const destroyToken = () => {
    window.localStorage.removeItem(ID_TOKEN_KEY)
}

export default { getToken, saveToken, destroyToken }