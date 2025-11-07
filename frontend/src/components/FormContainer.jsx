import React, { useRef, useEffect } from "react";

const FormContainer = ({ children, editTarget }) => {
  const ref = useRef(null);

  useEffect(() => {
    if (editTarget && ref.current) {
      ref.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }, [editTarget]);

  return (
    <div ref={ref} className="mb-6 p-4 md:p-6 bg-white rounded shadow">
      {children}
    </div>
  );
};

export default FormContainer;