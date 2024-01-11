import {useRef, useState, useEffect, useCallback} from 'react'

export default function AuthHook() {
    const [token, setToken] = useState(null);
    const [userId, setUserId] = useState();
    const [deadlineToken, setDeadlineToken] = useState();
  
  
    const tokenTimeRef = useRef();
  
    useEffect(() => {
      const userData = JSON.parse(localStorage.getItem('userData'));
      if(!userData) {
        return ;
      }
      else {
        login(userData.userId, userData.token, userData.expiredDateToken);
      }
    } , []);
  
    const login = useCallback((userId, token, expiredDateToken) => {
  
      setToken(token);
      setUserId(userId);
      const userData = {
        userId ,
        token,
  
      }
  
    
      const deadline  = expiredDateToken || new Date(new Date().getTime() + 3600*1000);
      userData.expiredDateToken = deadline;
      setDeadlineToken(deadline );
      localStorage.setItem('userData', JSON.stringify(userData));
  
    }, []);
  
    const logout = useCallback(() => {
      console.log('loged out')
      setToken(null);
      setUserId(null);
      localStorage.removeItem('userData');
    },[]);
  
    useEffect(() => {
      if(token && deadlineToken) {
        const timeRemain = new Date(deadlineToken).getTime() - new Date().getTime();
        tokenTimeRef.current = setTimeout(logout, timeRemain);
      }
      else {
        clearTimeout(tokenTimeRef);
      }
    }, [token, logout])
  return {login, logout, token, userId};
}
