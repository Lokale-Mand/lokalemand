import React, { useEffect, useState } from "react";
import { IoChevronUp } from "react-icons/io5";
import { useSelector } from "react-redux";

const ScrollTop = () => {

    const [isvisible, setIsvisible] = useState(false);

    const toggleVisibility = () => {
        if (window.pageYOffset > 300) {
            setIsvisible(true);
        } else {
            setIsvisible(false);
        }
    };

    const scrollToTop = () => {
        window.scrollTo({
            top: 0,
            behavior: "smooth",
        });
    };

    useEffect(() => {
        window.addEventListener("scroll", toggleVisibility);
        return () => {
            window.removeEventListener("scroll", toggleVisibility);
        };
    }, []);

    const setting = useSelector((state)=> state.setting)
    

    return (
        <div className="scroll-to-top">
            {isvisible && (
                <div onClick={scrollToTop} className="back-top-container">
                    <IoChevronUp size={26} />
                </div>
            )}
            
        </div>
    );
};
export default ScrollTop;