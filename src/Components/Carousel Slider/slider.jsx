import React, { useState, useEffect, useCallback } from "react";
import "./carousel.css";

import img1 from "../Assets/img1.jpg";
import img2 from "../Assets/img2.jpg";
import img3 from "../Assets/img3.jpg";
import img4 from "../Assets/img4.jpg";

const images = [
  { 
    src: img1, 
    author: "LUNDEV", 
    title: "INDIA", 
    topic: "BJP", 
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit." 
  },
  { 
    src: img2, 
    author: "LUNDEV", 
    title: "INDIA", 
    topic: "CONGRESS", 
    description: "Sed do eiusmod tempor incididunt ut labore et dolore." 
  },
  { 
    src: img3, 
    author: "LUNDEV", 
    title: "INDIA", 
    topic: "AAP", 
    description: "Ut enim ad minim veniam, quis nostrud exercitation." 
  },
  { 
    src: img4, 
    author: "LUNDEV", 
    title: "INDIA", 
    topic: "ARCHITECTURE", 
    description: "Duis aute irure dolor in reprehenderit in voluptate." 
  }
];

const Carousel = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isAutoPlaying, setIsAutoPlaying] = useState(true);
  const autoPlayInterval = 5000;

  const goToNextSlide = useCallback(() => {
    setCurrentIndex(prevIndex => (prevIndex + 1) % images.length);
  }, [images.length]);

  const goToPrevSlide = useCallback(() => {
    setCurrentIndex(prevIndex => (prevIndex - 1 + images.length) % images.length);
  }, [images.length]);

  const goToSlide = (index) => {
    setCurrentIndex(index);
    // When manually navigating, pause auto-play temporarily
    setIsAutoPlaying(false);
    setTimeout(() => setIsAutoPlaying(true), autoPlayInterval * 2);
  };

  useEffect(() => {
    let intervalId;
    if (isAutoPlaying) {
      intervalId = setInterval(goToNextSlide, autoPlayInterval);
    }
    return () => clearInterval(intervalId);
  }, [isAutoPlaying, goToNextSlide]);

  // Reset auto-play timer when user interacts
  const handleInteraction = () => {
    setIsAutoPlaying(false);
    const timeout = setTimeout(() => {
      setIsAutoPlaying(true);
    }, autoPlayInterval * 2);
    return () => clearTimeout(timeout);
  };

  return (
    <div className="carousel">
      <div className="list">
        {images.map((item, index) => (
          <div 
            className={`item ${index === currentIndex ? "active" : ""}`} 
            key={index}
          >
            <img src={item.src} alt={item.title} />
            <div className="content">
              <div className="author">{item.author}</div>
              <div className="title">{item.title}</div>
              <div className="topic">{item.topic}</div>
              <div className="des">{item.description}</div>
              <div className="buttons">
                <button>SEE MORE</button>
                <button>VOTE</button>
              </div>
            </div>
          </div>
        ))}
      </div>
      
      <div className="thumbnail">
        {images.map((item, index) => (
          <div 
            className={`item ${index === currentIndex ? "active" : ""}`} 
            key={index} 
            onClick={() => goToSlide(index)}
          >
            <img src={item.src} alt={item.title} />
            <div className="content">
              <div className="title">{item.title}</div>
              <div className="description">{item.description}</div>
            </div>
          </div>
        ))}
      </div>

      <div className="arrows">
        <button 
          onClick={() => {
            goToPrevSlide();
            handleInteraction();
          }}
          aria-label="Previous slide"
        >
          ❮
        </button>
        <button 
          onClick={() => {
            goToNextSlide();
            handleInteraction();
          }}
          aria-label="Next slide"
        >
          ❯
        </button>
      </div>

      <div className="indicators">
        {images.map((_, index) => (
          <button
            key={index}
            className={`indicator ${index === currentIndex ? "active" : ""}`}
            onClick={() => goToSlide(index)}
            aria-label={`Go to slide ${index + 1}`}
          />
        ))}
      </div>

      <div className="time">
        <div 
          className="progress" 
          style={{ 
            animationDuration: `${autoPlayInterval}ms`,
            animationPlayState: isAutoPlaying ? 'running' : 'paused' 
          }} 
        />
      </div>
    </div>
  );
};

export default Carousel;