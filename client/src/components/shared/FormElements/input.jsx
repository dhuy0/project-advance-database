import React, { useReducer, useEffect } from "react";

import { validate, VALIDATOR_TRUE } from "../../../utils/validators";
import "./input.css";

const inputReducer = (state, action) => {
  switch (action.type) {
    case "CHANGE":
      return {
        ...state,
        value: action.val,
        ...validate(action.val, action.validators),
      };
    case "TOUCH": 
      return {
        ...state,
        isTouched: true,
        ...validate(action.val, action.validators),
      };
    case "TRIGGER" : {
      return {
        ...state,
        ...validate(action.val, action.validators),
        trigger : true
      }
    }
    default:
      return state;
  }
};

const Input = (props) => {
  const [inputState, dispatch] = useReducer(inputReducer, {
    value: props.initialValue || '',
    isValid:props.initialValidity || false,
    isTouched: false,
    errType : "",
    trigger : false
  });

  const {id, onInput, listenTo} = props;
  const {value, isValid} = inputState;
  useEffect(() => {
    props.onInput(id,
    inputState.value,
    inputState.isValid)
  }, [id,value,isValid,onInput])

  useEffect (() => {
    triggerHandler();
  },[listenTo && listenTo.ele])

  const changeHandler = (event) => {
    dispatch({ 
      type: "CHANGE",
      val: event.target.value ,
      validators: props.validators
  })
  };

  const triggerHandler = () => {
    let triggers 
    if(!props.listenTo)  {
      triggers = [VALIDATOR_TRUE()];
    }
    else triggers = [...listenTo.triggers]
    dispatch ({
      type : "TRIGGER",
      val : inputState.value,
      validators : triggers
    })
  }


  const touchHandler = (event) => {

    dispatch({
      type: "TOUCH",
      val : event.target.value,
      validators: props.validators
    });
  };

  let element ;
    if ( props.element === "input" ){
      element = <input
      id={props.id}
      type={props.type}
      placeholder={props.placeholder}
      onChange={changeHandler}
      onBlur={ touchHandler}
      value={inputState.value}
    />
    }
    else {
      element = <textarea
      id={props.id}
      rows={props.rows || 3}
      onChange={changeHandler}
      onBlur={touchHandler}
      value={inputState.value}
    />
    }
  return (
    <div
      className={`my-form-control ${
        !inputState.isValid && inputState.isTouched && "my-form-control--invalid"
      }`}
    >
      <label htmlFor={props.id}>{props.lable} </label>
      {element}
      {!inputState.isValid && (inputState.trigger || inputState.isTouched) && <p>{props.errorText[inputState.errType]}</p>}


    </div>
  );
};

export default Input;
