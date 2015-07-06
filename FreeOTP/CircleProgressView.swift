//
// FreeOTP
//
// Authors: Nathaniel McCallum <npmccallum@redhat.com>
//
// Copyright (C) 2015  Nathaniel McCallum, Red Hat
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import UIKit

class CircleProgressView : UIView {
    var hollow: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    var clockwise: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    var threshold: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        backgroundColor = UIColor.clearColor()
    }

    override func drawRect(rect: CGRect) {
        let prog = self.clockwise ? self.progress : (1.0 - self.progress)
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        let radius = max(min(self.bounds.size.height / 2.0, self.bounds.size.width / 2.0) - 4, 1)
        let radians = max(min(Double(prog) * 2 * M_PI, 2 * M_PI), 0)

        var color = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        if (threshold < 0 && progress < fabs(threshold)) {
            color = UIColor(red: 1.0, green: progress * (1 / fabs(threshold)), blue: 0.0, alpha: 1.0)
        } else if (threshold > 0 && progress > threshold) {
            color = UIColor(red: 1.0, green: (1 - progress) * (1 / (1 - threshold)), blue: 0.0, alpha: 1.0)
        }

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(-M_PI_2),
            endAngle: CGFloat(radians - M_PI_2), clockwise: self.clockwise)
        if (self.hollow) {
            color.setStroke()
            path.lineWidth = 3.0
            path.stroke()
        } else {
            color.setFill()
            path.addLineToPoint(center)
            path.addClip()
            UIRectFill(self.bounds);
        }
    }
}
