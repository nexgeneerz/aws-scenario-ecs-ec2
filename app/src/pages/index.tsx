import Image from 'next/image'
import {Inter} from 'next/font/google'
import logo from '../public/logo.png'

const inter = Inter({subsets: ['latin']})

const LogoImage = () => {
    return (
        <Image
            src={logo}
            alt="nexgeneerz.io"
            width="350"
            height="300"
        />
    )
}

export default function Home() {
    return (
        <section className="h-screen flex bg-gradient-to-br from-pink-600 to-cyan-500">
            <div className="py-8 px-4 m-auto max-w-screen-xl text-center lg:py-16 lg:px-12">
                <div className="h-20">
                    <a href="https://nexgeneerz.io" target="_blank" className="cursor-pointer">
                        <Image
                            src={logo.src}
                            alt="nexgeneerz.io – Hands-on Consulting for Cloud Computing"
                            width="200"
                            height="50"
                            className="mx-auto"
                        />
                    </a>
                </div>
                <h1 className="mb-16 text-4xl font-extrabold tracking-tight leading-none md:text-5xl lg:text-6xl text-white">Cloud-native
                    foundation for your success<span className="text-pink-600">.</span></h1>
                <p className="mb-8 text-lg font-normal lg:text-xl sm:px-16 xl:px-48 text-white">Build fully-automated
                    infrastructure solutions for your business, <br/> cost-effectively and in a short time. </p>
                <div
                    className="flex flex-col mb-8 lg:mb-16 space-y-4 sm:flex-row sm:justify-center sm:space-y-0 sm:space-x-4">
                    <a href="https://nexgeneerz.io/cloud-for-startups-aws/" target="_blank"
                       className="inline-flex justify-center items-center py-3 px-5 text-base font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300">
                        Learn more
                        <svg className="ml-2 -mr-1 w-5 h-5" fill="currentColor" viewBox="0 0 20 20"
                             xmlns="http://www.w3.org/2000/svg">
                            <path fill-rule="evenodd"
                                  d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z"
                                  clip-rule="evenodd"></path>
                        </svg>
                    </a>
                    <a href="https://www.linkedin.com/company/nexgeneerz/" target="_blank"
                       className="inline-flex justify-center items-center py-3 px-5 text-base font-medium text-center text-white rounded-lg border border-white hover:bg-white hover:bg-opacity-10 focus:ring-4 focus:ring-gray-100">
                        <svg className="mr-2 -ml-1 w-5 h-5" fill="currentColor" xmlns="http://www.w3.org/2000/svg"
                             viewBox="0 0 448 512">
                            <path
                                d="M416 32H31.9C14.3 32 0 46.5 0 64.3v383.4C0 465.5 14.3 480 31.9 480H416c17.6 0 32-14.5 32-32.3V64.3c0-17.8-14.4-32.3-32-32.3zM135.4 416H69V202.2h66.5V416zm-33.2-243c-21.3 0-38.5-17.3-38.5-38.5S80.9 96 102.2 96c21.2 0 38.5 17.3 38.5 38.5 0 21.3-17.2 38.5-38.5 38.5zm282.1 243h-66.4V312c0-24.8-.5-56.7-34.5-56.7-34.6 0-39.9 27-39.9 54.9V416h-66.4V202.2h63.7v29.2h.9c8.9-16.8 30.6-34.5 62.9-34.5 67.2 0 79.7 44.3 79.7 101.9V416z"/>
                        </svg>
                        Follow on LinkedIn
                    </a>
                </div>
            </div>
        </section>
    )
}
